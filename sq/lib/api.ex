defmodule Api do
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
            %{
              letra: primeira_musica["text"],
              link: primeira_musica["url"],
              nome_artista: artista_encontrado
            }

          _ -> {:error, "Erro ao decodificar resposta do Vagalume"}
        end

      {:ok, %HTTPoison.Response{status_code: status_code}} when status_code == 502 and tentativas > 0 ->
        # Espera 1 segundo antes de tentar novamente
        :timer.sleep(1000)
        buscar_letra_no_vagalume(nome_artista, nome_musica, tentativas - 1)

      {:ok, %HTTPoison.Response{status_code: status_code}} when status_code != 200 ->
        {:error, "Erro HTTP #{status_code}: Problema ao acessar a API do Vagalume"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Erro na solicitação HTTP: #{reason}"}
    end
  end

  #Api.verificar_palavra_na_letra("Michael Jackson","Thriller","night")
  # Função para verificar se uma palavra está na letra da música (com correspondência exata)
  def verificar_palavra_na_letra(artista, musica, palavra) do
    # Buscar a letra da música no Vagalume
    case buscar_letra_no_vagalume(artista, musica) do
      # Quando a letra é encontrada, extrair letra, link e nome do artista
      %{letra: letra, link: link_vagalume, nome_artista: nome_artista} ->
        # Substituir quebras de linha por espaços para evitar problemas com o \n
        letra_normalizada = String.replace(letra, ~r/\n|\r/, " ")

        # Usar Regex para verificar correspondência exata da palavra
        regex = ~r/\b#{Regex.escape(palavra)}\b/i

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

      # Caso não consiga buscar a letra, retorna um erro
      {:error, reason} ->
        {:error, "Erro ao buscar letra no Vagalume: #{reason}"}

      _ ->
        {:error, "Formato inesperado ao buscar letra no Vagalume"}
    end
  end
end
