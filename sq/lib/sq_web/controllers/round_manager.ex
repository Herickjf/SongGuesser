defmodule SqWeb.RoundManager do
  use GenServer

  def init(init_arg) do
    {:ok, init_arg}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def handle_info(:new_round, state) do
    # lógica para escolher uma palavra aleatória e reiniciar a rodada
    :timer.send_after(30000, self(), :new_round)  # 30 segundos para próxima rodada
    {:noreply, state}
  end
end
