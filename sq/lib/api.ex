defmodule Api do
  @url_deezer "https://api.deezer.com"
  @url_vagalume "https://api.vagalume.com.br/search.php"

  # Carregar variáveis do .env
  Dotenv.load()

  # Pega a chave da API do ambiente
  @api_key System.get_env("api_key")

  # Função para validar parâmetros de entrada
  defp validar_parametros(artista, musica) do
    cond do
      artista == nil or artista == "" ->
        {:error, %{"valid" => false, "message" => "artist input is invalid, try to be more precise"}}

      musica == nil or musica == "" ->
        {:error, %{"valid" => false, "message" => "music input is invalid, try to be more precise"}}

      true -> :ok
    end
  end

  # Função para buscar músicas no Deezer
  def buscar_musica_no_deezer(artista, musica) do
    case validar_parametros(artista, musica) do
      :ok ->
        # Codificar os parâmetros adequadamente
        query = URI.encode("#{artista} #{musica}")
        url = "#{@url_deezer}/search?q=#{query}"

        case HTTPoison.get(url) do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            case Jason.decode(body) do
              {:ok, %{"data" => musicas}} ->
                # Limitar o número de músicas retornadas a no máximo 5
                Enum.take(musicas, 5)

              _ -> {:error, "Erro ao decodificar resposta do Deezer"}
            end

          {:error, %HTTPoison.Error{reason: reason}} ->
            {:error, reason}
        end

      {:error, erro_json} -> {:error, erro_json}
    end
  end

  # Função para buscar a letra da música no Vagalume
  def buscar_letra_no_vagalume(nome_musica, nome_artista) do
    url = "#{@url_vagalume}?art=#{URI.encode(nome_artista)}&mus=#{URI.encode(nome_musica)}&apikey=#{@api_key}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"mus" => [primeira_musica | _]}} ->
            %{
              letra: primeira_musica["text"],
              link: primeira_musica["url"]
            }
          _ -> {:error, "Erro ao decodificar resposta do Vagalume"}
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  # Função para verificar se uma palavra está na letra da música (com correspondência exata)
  def verificar_palavra_na_letra(musica, artista, palavra) do
    case buscar_musica_no_deezer(artista, musica) do
      {:error, reason} -> {:error, reason}
      musicas_deezer ->
        # Buscar letra da música correspondente no Vagalume
        case buscar_letra_no_vagalume(musica, artista) do
          %{letra: letra, link: link_vagalume} ->
            # Substituir quebras de linha por espaços para evitar problemas com o \n
            letra_normalizada = String.replace(letra, "\n", " ")

            # Usar Regex para verificar correspondência exata da palavra
            regex = ~r/\b#{Regex.escape(palavra)}\b/i

            if Regex.match?(regex, letra_normalizada) do
              primeira_musica = List.first(musicas_deezer)

              # Retornar todas as informações se a palavra estiver na letra
              %{
                accepted: true,
                link_vagalume: link_vagalume,
                lyrics: letra,
                link_deezer: primeira_musica["link"],
                imagem_album: primeira_musica["album"]["cover_medium"],
                imagem_artista: primeira_musica["artist"]["picture_medium"],
                nome_musica: primeira_musica["title"],
                nome_artista: primeira_musica["artist"]["name"]
              }
            else
              # Se a palavra não estiver na letra, retornar apenas o link do Vagalume
              %{
                accepted: false,
                link_vagalume: link_vagalume
              }
            end

          _ ->
            {:error, "Erro ao buscar letra no Vagalume"}
        end
    end
  end
end
