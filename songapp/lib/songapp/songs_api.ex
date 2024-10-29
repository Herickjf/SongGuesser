defmodule Songapp.SongsApi do

  use Phoenix.Controller
  # Funcoes para utilizar as APIs
  # def search(conn, params) do
  #   %{"artist" => artist_name, "song" => song_name} = params
  #   result = buscar_musicas_deezer(artist_name, song_name)
  #   json(conn, result)
  # end

  # def validate(conn, %{"chosen" => chosen, "word" => word}) do
  #   result = verificar_palavra_na_letra(chosen["artist"], chosen["song"], word)
  #   json(conn, result)
  # end

  # def getWord(conn, %{"language" => lg, "alreadyReceived" => alreadyReceived}) do
  #   result = buscar_palavra_aleatoria(lg, alreadyReceived)
  #   json(conn, %{message: "Busca realizada", result: result})
  # end

  def buscar_palavra_aleatoria(linguagem, palavras_usadas) do
    caminho_arquivo = "/dados/#{linguagem}.txt"

    case File.read(caminho_arquivo) do
      {:ok, conteudo} ->
        # Remove espaços em branco e caracteres de nova linha
        palavras =
          conteudo
          |> String.split("\n")
          |> Enum.map(&String.trim/1) # Limpa as palavras

        # Remove palavras vazias
        palavras_disponiveis = Enum.reject(palavras, &(&1 == ""))

        # Filtra palavras usadas
        palavras_filtradas = Enum.reject(palavras_disponiveis, fn palavra ->
          palavra in palavras_usadas
        end)

        if length(palavras_filtradas) > 0 do
          Enum.random(palavras_filtradas)
        else
          "Nenhuma palavra disponível"
        end

      {:error, _reason} ->
        "Erro ao ler o arquivo"
    end
  end

  @url_deezer "https://api.deezer.com/search"
  @url_vagalume "https://api.vagalume.com.br/search.php"
  @api_key "e0abe525994c81dee72054d2ebc34370"

  # Função para validar parâmetros de entrada
  def validar_parametros(artista, musica) do
    cond do
      artista == nil or artista == "" ->
        {:error, %{"valid" => false, "message" => "artist input is invalid, try to be more precise"}}

      musica == nil or musica == "" ->
        {:error, %{"valid" => false, "message" => "music input is invalid, try to be more precise"}}

      true -> :ok
    end
  end

  def buscar_musicas_deezer(nome_artista, nome_musica) do
    case validar_parametros(nome_artista, nome_musica) do
      :ok ->
        query = URI.encode("#{nome_artista} #{nome_musica}")
        url = "#{@url_deezer}?q=#{query}"

        case HTTPoison.get(url) do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            case Jason.decode(body) do
              {:ok, %{"data" => musicas}} when is_list(musicas) and length(musicas) > 0 ->
                # Limitar o número de músicas retornadas a no máximo 5
                musicas_limitadas = Enum.take(musicas, 5)
                found =
                  Enum.map(musicas_limitadas, fn musica ->
                    %{
                      artist: musica["artist"]["name"],
                      song: musica["title"],
                      link: musica["link"],
                      #album: musica["album"]["title"],
                      #album_link: musica["album"]["link"],
                      album_image: musica["album"]["cover"],
                      #artist_link: musica["artist"]["link"],
                      #cover: musica["album"]["cover"],
                      #duration: musica["duration"]
                    }
                  end)

                resultado = %{
                  valid: true,
                  amount: length(found),
                  found: found
                }

                Jason.encode!(resultado)

              {:ok, _} ->
                Jason.encode!(%{"valid" => true, "amount" => 0, "found" => []})

              _ ->
                Jason.encode!(%{error: "Erro ao decodificar resposta do Deezer"})
            end

          {:ok, %HTTPoison.Response{status_code: status_code}} when status_code != 200 ->
            Jason.encode!(%{error: "Erro HTTP: #{status_code}"})

          {:error, %HTTPoison.Error{reason: reason}} ->
            Jason.encode!(%{error: reason})
        end

      {:error, erro_json} ->
        Jason.encode!(%{error: erro_json})
    end
  end

  # Função para buscar a letra da música no Vagalume
  def buscar_letra_no_vagalume(nome_artista, nome_musica, tentativas \\ 3) do
    url = "#{@url_vagalume}?art=#{URI.encode(nome_artista)}&mus=#{URI.encode(nome_musica)}&apikey=#{@api_key}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"mus" => [primeira_musica | _], "art" => %{"name" => artista_encontrado}}} ->
            resultado = %{
              letra: primeira_musica["text"],
              link: primeira_musica["url"],
              nome_artista: artista_encontrado
            }

            Jason.encode!(resultado)

          _ -> Jason.encode!(%{error: "Erro ao decodificar resposta do Vagalume"})
        end

      {:ok, %HTTPoison.Response{status_code: status_code}} when status_code == 502 and tentativas > 0 ->
        # Espera 1 segundo antes de tentar novamente
        :timer.sleep(1000)
        buscar_letra_no_vagalume(nome_artista, nome_musica, tentativas - 1)

      {:ok, %HTTPoison.Response{status_code: status_code}} when status_code != 200 ->
        Jason.encode!(%{error: "Erro HTTP #{status_code}: Problema ao acessar a API do Vagalume"})

      {:error, %HTTPoison.Error{reason: reason}} ->
        Jason.encode!(%{error: "Erro na solicitação HTTP: #{reason}"})
    end
  end

  # Função para verificar se uma palavra está na letra da música (com correspondência exata)
  def verificar_palavra_na_letra(artista, musica, palavra) do
    # Buscar a letra da música no Vagalume
    case buscar_letra_no_vagalume(artista, musica) do
      # Decodificar a resposta JSON
      json_response when is_binary(json_response) ->
        case Jason.decode(json_response) do
          # Quando a letra é encontrada, extrair letra, link e nome do artista
          {:ok, %{"letra" => letra, "link" => link_vagalume, "nome_artista" => nome_artista}} ->
            # Substituir quebras de linha por espaços para evitar problemas com o \n
            letra_normalizada = String.replace(letra, ~r/\n|\r/, " ")

            # Usar Regex para verificar correspondência exata da palavra
            regex = ~r/\b#{Regex.escape(palavra)}\b/i

            resultado =
              if Regex.match?(regex, letra_normalizada) do
                # Retornar todas as informações se a palavra estiver na letra
                %{
                  accepted: true,
                  link_vagalume: link_vagalume,
                  lyrics: letra,
                  nome_musica: musica,
                  nome_artista: nome_artista
                }
              else
                # Se a palavra não estiver na letra, retornar apenas o link do Vagalume
                %{
                  accepted: false,
                  link_vagalume: link_vagalume
                }
              end

            Jason.encode!(resultado)

          # Caso não consiga decodificar a resposta JSON, retorna um erro
          _ -> Jason.encode!(%{error: "Erro ao decodificar resposta JSON"})
        end

      # Caso não consiga buscar a letra, retorna um erro
      {:error, reason} ->
        Jason.encode!(%{error: "Erro ao buscar letra no Vagalume: #{reason}"})

      _ ->
        Jason.encode!(%{error: "Formato inesperado ao buscar letra no Vagalume"})
    end
  end
end
