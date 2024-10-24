defmodule SongappWeb.PageController do
  use SongappWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def index(conn, _params) do
    conn
    |> put_resp_content_type("text/html")
    |> send_file(200, "priv/static/index.html")
  end

  def about(conn, _params) do
    conn
    |> put_resp_content_type("text/html")
    |> send_file(200, "priv/static/aboutUs.html")
  end

  def howToPlay(conn, _params) do
    conn
    |> put_resp_content_type("text/html")
    |> send_file(200, "priv/static/howToPlay.html")
  end

  def search(conn, params) do
    IO.puts(params)
    params
    json(conn, %{message: "Busca realizada", params: params})
    #%{"artist" => artist_name, "song" => song_name} = params

    #result = Api.buscar_musicas_deezer(artist_name, song_name)
  end

  def validate(conn, %{"word" => word, "chosen" => chosen}) do
    result = Api.validar_palavra(word, chosen)
    json(conn, %{message: "Busca realizada", result: result})
  end

  def getWord(conn, %{"language" => lg, "alreadyReceived" => alreadyReceived}) do
    result = buscar_palavra_aleatoria(lg, alreadyReceived)
    json(conn, %{message: "Busca realizada", result: result})
  end

  defp buscar_palavra_aleatoria(linguagem, palavras_usadas) do
    caminho_arquivo = "/songapp/priv/dados/#{linguagem}.txt"

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
end
