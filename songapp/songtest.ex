defmodule Songapp.SongsApi do
  use Phoenix.Controller

  # URLs das APIs
  @url_deezer     "https://api.deezer.com/search"
  @url_vagalume   "https://api.vagalume.com.br/search.php"
  @url_genius     "https://api.genius.com/search"
  @url_lyricsovh  "https://api.lyrics.ovh/v1"

  # Chaves de acessos às APIs
  @vagalume_key  "e0abe525994c81dee72054d2ebc34370"
  @genius_key    "lOyfiGyagQRmbbKwPv3RjgkecQ1HaPhLqrd2O9vUxr_sQKaBOd8Xy9rhrrpayWBW"
  @header        [{"Authorization", "Bearer #{@genius_key}"}]


  #@api

  #################################################################################
  # PARTE 1: APIS GENIUS E LYRICS.OVH

  def get_lyrics(artist, song) do
    mp = %{artist: artist, title: song}

    case get_lyrics2(mp) do
      {:error, _} ->
        get_lyrics1(mp)

      response ->
        response
    end

  end

  defp get_lyrics2(input) do
    artist = input[:artist]
    title = Regex.replace(~r/\([^)]*\)/,input[:title], "")
    url = "#{@url_lyricsovh}/#{URI.encode(artist)}/#{URI.encode(title)}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()
        |> handle_response()

      {:ok, %HTTPoison.Response{status_code: 404, body: _body}} ->
        {:error, "Letra não encontrada"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}

      _ ->
        {:error, "Erro desconhecido"}
    end
  end

  defp handle_response(%{
          "lyrics" => %{
            "lyrics_body" => lyrics
          }
        }
    ) do
        # Se a letra está em ASCII, converta para texto legível
        lyrics
        |> String.to_charlist()        # Converte a string de ASCII para uma lista de inteiros
        |> Enum.map(&(&1))             # Converte cada inteiro ASCII para seu caractere correspondente
        |> List.to_string()            # Converte a lista de caracteres para uma string

        {:ok, lyrics}
  end

  defp handle_response(%{"lyrics" => lyrics}) do
    {:ok, lyrics}
  end

  defp handle_response(_), do: {:error, "Letra não encontrada"}

  defp find_new_song(songs, retrieved_songs) do
    case Enum.find(songs, fn song -> song not in retrieved_songs end) do
      nil -> :error
      song -> {:ok, song}
    end
  end

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

  defp get_lyrics1(mp) do
    song_name = mp[:title] <> " " <> mp[:artist]

    encoded_query = URI.encode_www_form(song_name)
    url = "#{@url_genius}?q=#{encoded_query}"

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

          {:ok, lyrics_final1}
        else
          error ->
            {:error, "Não foi possível obter as letras."}
        end

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:error, {:http_error, status_code, body}}

      {:error, error} ->
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


  defp map([], _f), do: []
  defp map([head | tail], f), do: [f.(head) | map(tail, f)]


  #################################################################################
  # PARTE 2: APIS DEEZER E VAGALUME

  def buscar_info_musica_deezer(id) do
    # URL específica para buscar detalhes de uma música no Deezer usando o ID da música
    url = "https://api.deezer.com/track/#{id}"

    # Faz a requisição HTTP GET para a URL
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        # Decodifica o corpo da resposta JSON
        case Jason.decode(body) do
          {:ok, resultado_consulta} ->

            # Cria o JSON com as informações desejadas
            resultado = %{
              album_link: resultado_consulta["album"]["cover_medium"],  # Link para a capa do álbum (tamanho médio)
              music_preview: resultado_consulta["preview"]               # Link para o preview da música
            }

            %{valid: true, result: resultado}

          {:ok, _} ->
            %{valid: false, error: "Dados insuficientes retornados pela API do Deezer"}

          _ ->
            %{valid: false, error: "Erro ao decodificar a resposta do Deezer"}
        end

      {:ok, %HTTPoison.Response{status_code: status_code}} when status_code != 200 ->
        %{valid: false, error: "Erro HTTP: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        %{valid: false, error: reason}
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

                resultado

              {:ok, _} ->
                %{"valid" => true, "amount" => 0, "found" => []}

              _ ->
                %{error: "Erro ao decodificar resposta do Deezer"}
            end

          {:ok, %HTTPoison.Response{status_code: status_code}} when status_code != 200 ->
            %{error: "Erro HTTP: #{status_code}"}

          {:error, %HTTPoison.Error{reason: reason}} ->
            %{error: reason}
        end

      {:error, erro_json} ->
        %{error: erro_json}
    end
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

  def buscar_palavra_aleatoria(linguagem, palavras_usadas) do
    caminho_arquivo = Path.expand("dados/#{linguagem}.txt", __DIR__)

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

  defp handle_response(%{ "lyrics" => %{ "lyrics_body" => lyrics }}) do
    # Se a letra está em ASCII, converta para texto legível
    lyrics
    |> String.to_charlist()        # Converte a string de ASCII para uma lista de inteiros
    |> Enum.map(&(&1))             # Converte cada inteiro ASCII para seu caractere correspondente
    |> List.to_string()            # Converte a lista de caracteres para uma string

    {:ok, lyrics}

  end

  defp handle_response(%{"lyrics" => lyrics}) do
    {:ok, lyrics}
  end

  defp handle_response(_), do: {:error, "Letra não encontrada"}

  defp buscar_letra_no_vagalume(nome_artista, nome_musica) do
    url = "#{@url_vagalume}?art=#{URI.encode(nome_artista)}&mus=#{URI.encode(nome_musica)}&apikey=#{@api_key}"

    # Faz a requisição HTTP para a URL

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        # Decodifica o corpo da resposta JSON
        decoded_body = Jason.decode!(body)

        # Verifica se a letra foi encontrada
        if decoded_body["type"] == "exact" do
          # Retorna a letra da música
          lyrics = decoded_body["mus"][0]["text"]
          {:ok, lyrics}
        else
          {:error, "Letra não encontrada"}
        end

      {:ok, %HTTPoison.Response{status_code: status_code}} when status_code != 200 ->
        {:error, "Erro HTTP: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def verificar_palavra_na_letra(artista, musica, palavra) do
    regex = ~r/\b#{Regex.escape(palavra)}\b[^\w]|[^\w]\b#{Regex.escape(palavra)}\b/i

    case buscar_letra_no_vagalume(artista, musica) do
      {:ok, lyrics} ->
        letra_normalizada = String.replace(lyrics, ~r/\n|\r/, " ")
        if Regex.scan(regex, letra_normalizada) != [] do
          %{accepted: true, lyrics: lyrics}
        else
          %{accepted: false, message: "A palavra '#{palavra}' não foi encontrada na letra da música"}
        end

      {:error, reason} ->
        case get_lyrics(artista, musica) do
          {:ok, lyrics} ->
            letra_normalizada = String.replace(lyrics, ~r/\n|\r/, " ")
            if Regex.scan(regex, letra_normalizada) != [] do
              %{accepted: true, lyrics: lyrics}
            else
              %{accepted: false, message: "A palavra '#{palavra}' não foi encontrada na letra da música"}
            end

          {:error, _} ->
            %{accepted: false, message: "Erro ao buscar a letra da música"}

          _ ->
            %{accepted: false, message: "Erro desconhecido"}
        end
    end
  end
end
