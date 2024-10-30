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
    caminho_arquivo = Path.expand("dados/#{linguagem}.txt", __DIR__)
    IO.puts("Caminho do arquivo: #{caminho_arquivo}")

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
        caminho_arquivo
        # "Erro ao ler o arquivo"
    end
  end

  @url_deezer "https://api.deezer.com/search"
  @url_vagalume "https://api.vagalume.com.br/search.php"
  @api_key "e0abe525994c81dee72054d2ebc34370"
  @url_genius "https://api.genius.com/search"
  @genius_key "lOyfiGyagQRmbbKwPv3RjgkecQ1HaPhLqrd2O9vUxr_sQKaBOd8Xy9rhrrpayWBW"
  @header [{"Authorization", "Bearer #{@genius_key}"}]


  defp extract_song_info(%{"response" => %{"hits" => hits}}) do
    Enum.map(hits, fn hit ->
      result = hit["result"]
      %{
        title: result["title"],
        artist: result["primary_artist"]["name"],
        release_date: result["release_date_for_display"],
        song_url: result["url"]
      }
    end)
  end
  defp extract_song_info(_), do: []

  defp extract_song_info2(%{"response" => %{"hits" => [hit | _]}}) do
    result = hit["result"]

    %{
      title: result["title"],
      artist: result["primary_artist"]["name"],
      release_date: result["release_date_for_display"],
      song_url: result["url"],
    }
  end

  def buscar_letra_genius(nome_artista, nome_musica) do
    query = URI.encode("#{nome_artista} #{nome_musica}")
    url = "#{@url_genius}?q=#{query}"

    case HTTPoison.get(url, @header) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"response" => %{"hits" => [primeiro_hit | _]}}} ->
            result = primeiro_hit["result"]
            song_url = result["url"]

            # Busca a página de letras para extrair a letra
            case HTTPoison.get(song_url) do
              {:ok, %HTTPoison.Response{status_code: 200, body: lyrics_body}} ->
                {:ok, document} = Floki.parse_document(lyrics_body)
                lyrics = extract_lyrics(document)
                {:ok, lyrics}

              {:error, _reason} ->
                {:error, "Erro ao buscar a letra no Genius"}
            end

          _ -> {:error, "Letra não encontrada no Genius"}
        end

      {:error, _reason} ->
        {:error, "Erro ao conectar à API do Genius"}
    end
  end

  defp handle_response(%{ "lyrics" => %{ "lyrics_body" => lyrics }}) do
    # Se a letra está em ASCII, converta para texto legível
    lyrics
    |> String.to_charlist()        # Converte a string de ASCII para uma lista de inteiros
    |> Enum.map(&(&1))             # Converte cada inteiro ASCII para seu caractere correspondente
    |> List.to_string()            # Converte a lista de caracteres para uma string
    |> IO.puts()                   # Exibe a letra convertida

    {:ok, lyrics}

  end

  defp handle_response(%{"lyrics" => lyrics}) do
    {:ok, lyrics}
  end

  defp handle_response(_), do: {:error, "Letra não encontrada"}

  defp get_lyrics1(mp) do
    song_name = mp[:title] <> " " <> mp[:artist]

    encoded_query = URI.encode_www_form(song_name)
    url = "#{@api_url}?q=#{encoded_query}"

    IO.puts("Buscando letras para: #{song_name}")
    IO.puts("URL de busca: #{url}")

    case HTTPoison.get(url, @header, follow_redirect: true) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        with {:ok, decoded_body} <- Poison.decode(body),
             %{"response" => %{"hits" => [hit | _]}} <- decoded_body,
             result = hit["result"],
             song_url = result["url"],
             {:ok, %HTTPoison.Response{status_code: 200, body: lyrics_body}} <- HTTPoison.get(song_url),
             {:ok, document} <- Floki.parse_document(lyrics_body) do

          lyrics = extract_lyrics(document)

          regex1 = ~r/\d+\sContributors/
          regex2 = ~r/\d+Contributors/

          [lyrics_final1 | _] = String.split(lyrics, regex1, parts: 2)
          [lyrics_final1 | _] = String.split(lyrics_final1, regex2, parts: 2)
          [lyrics_final1 | _] = String.split(lyrics_final1, "[Outro]", parts: 2)
          [lyrics_final1 | _] = String.split(lyrics_final1, "Read More", parts: 2)

          mapa = extract_song_info2(decoded_body)

          IO.puts("\n\nArtista: #{mapa[:artist]}")
          IO.puts("Título: #{mapa[:title]}")
          IO.puts("\nLetra:\n\n #{lyrics_final1}")

          {:ok, lyrics_final1}
        else
          error ->
            IO.puts("Erro ao obter as letras: #{inspect(error)}")
            {:error, "Não foi possível obter as letras."}
        end

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        IO.puts("Erro HTTP: #{status_code}")
        IO.puts("Corpo da Resposta: #{body}")
        {:error, {:http_error, status_code, body}}

      {:error, error} ->
        IO.puts("Falha na requisição: #{inspect(error)}")
        {:error, {:request_failed, error}}
    end
  end

  defp extract_lyrics(document) do
    # Tentar encontrar o seletor padrão
    lyrics =
      document
      |> Floki.find(".lyrics")
      |> Floki.text()
      |> String.trim()

    # Se não encontrar, tenta o contêiner mais recente
    lyrics = if lyrics == "" do
      document
      |> Floki.find(".Lyrics__Container")
      |> Enum.map(&Floki.text/1)
      |> Enum.join("\n")
      |> String.trim()
    else
      lyrics
    end

    # Se ainda não encontrar, tenta capturar todo o texto em divs e filtrar o que parece ser letra
    lyrics = if lyrics == "" do
      document
      |> Floki.find("div")
      |> Enum.map(&Floki.text/1)
      |> Enum.filter(fn text -> String.contains?(text, "\n") end) # Filtro básico para tentar pegar blocos de letra
      |> Enum.join("\n")
      |> String.trim()
    else
      lyrics
    end

    # Filtrar textos indesejados que não fazem parte da letra
    lyrics
    |> String.split("\n")
    |> Enum.reject(&String.contains?(&1, ["Sign Up", "Get tickets", "You might also like", "See Eminem Live", "Embed", "Cancel", "How to Format Lyrics", "Type out all lyrics", "Use section headers", "Use italics", "To learn more", "About", "Genius Annotation", "Share", "Q&A", "Find answers", "Ask a question", "Genius Answer", "It won’t appear", "When did", "Who wrote", "Greatish Hits", "Expand", "Credits", "Writer", "Release Date", "Real Love Baby Covers", "Real Love Baby Translations", "Tags", "Comments", "Sign Up", "Genius is the ultimate source", "Sign In", "Do Not Sell", "Terms of Use", "Verified Artists", "All Artists", "Hot Songs"]))
    |> Enum.join("\n")
  end


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
                      album_cover_link: musica["album"]["cover_medium"], # Link da capa do álbum (tamanho médio)
                      music_preview: musica["preview"], # Link do preview da música
                      music_id: musica["id"]
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

      {:ok, %HTTPoison.Response{status_code: 502}} when tentativas > 0 ->
        # Espera 1 segundo antes de tentar novamente
        :timer.sleep(1000)
        buscar_letra_no_vagalume(nome_artista, nome_musica, tentativas - 1)

      {:ok, %HTTPoison.Response{status_code: 502}} ->
        # Caso esgote as tentativas no Vagalume, tenta buscar com a API do Genius
        buscar_letra_genius(nome_artista, nome_musica)

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


          # Caso não consiga decodificar a resposta JSON, retorna um erro
          _ -> %{accepted: false, error: "Erro ao decodificar resposta JSON"}
        end

      # Caso não consiga buscar a letra, retorna um erro
      {:error, reason} ->
        %{accepted: false, error: "Erro ao buscar letra no Vagalume: #{reason}"}

      _ ->
        %{accepted: false, error: "Formato inesperado ao buscar letra no Vagalume"}
    end
  end
end
