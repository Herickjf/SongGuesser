---

# SongGuesser

**Team Members**: Luis Reis, Herick José, João Marcos Cunha, Lucas Fontes, Kaique Bezerra, and Rafael de França.

## Description

SongGuesser is an online game created with the Phoenix framework (Elixir) that challenges players to recall and cite songs containing a specific word. Inspired by the Elle channel segment, the game provides a fun and competitive environment where players test their musical memory and creativity in quick rounds.

## Access

The project is available online via AWS. To play, access:  
[http://15.228.220.61:4000/](http://15.228.220.61:4000/)  
*The server may be temporarily unavailable. Please wait or try running it locally.*

## Requirements

1. **Elixir** installed.
2. **Phoenix Framework** installed.
3. **PostgreSQL** configured with:
   - Username: `postgres`
   - Password: `postgres`

> If you are using different PostgreSQL credentials, update them in the configuration file (`config/dev.exs`).

## Installation

To set up and run the project locally, execute the following commands in the terminal:

1. Clone the repository:
   ```bash
   git clone https://github.com/Herickjf/SongGuesser
   cd SongGuesser
   ```

2. Install the dependencies:
   ```bash
   mix deps.get
   ```

3. Set up the database:
   ```bash
   mix ecto.create
   mix ecto.migrate
   ```

4. Start the server:
   ```bash
   mix phx.server
   ```

The server will be available at [http://localhost:4000](http://localhost:4000) if running locally.

## Game: How to Play

**Note:** The APIs may sometimes fail in searching, finding, or verifying song lyrics.

### Inspiration

The game is inspired by a segment where participants are given a word and must quickly recall a song that contains it. Our goal is to create a fun environment that tests players’ musical knowledge and mental agility.

### Step-by-Step Guide

1. **Enter Your Name and Join/Create a Room**  
   Enter your name to be identified in the game. You can:
   - Join an existing room using the code and password provided by the host.
   - Create a room and set a password for it.

2. **Room Settings**  
   As the host, you can configure the room by setting:
   - Number of Players (1 to 20)
   - Number of Rounds (3 to 15)
   - Game Language (Portuguese, English, or Spanish)
   - Choose an avatar.

3. **In the Waiting Room**  
   - Players wait until the host starts the game.
   - The host controls the game start.

4. **Starting the Game**  
   - Each round begins with a word prompt, and a timer starts.
   - Within 30 seconds, players must enter the artist and song name containing the word, then click "search."

5. **Song Selection**  
   After clicking "search," up to five song options will be displayed for each player, who should select their desired song and wait until time's out.

6. **Round Results**  
   - At the end of the round, a list of players' attempts is shown, indicating whether their choice was correct.
   - Each player can listen to a preview of the correct song and view additional information.

7. **Start of New Rounds**  
   - The host determines when to start each new round.

8. **Final Ranking**  
   - At the end of all rounds, the top three scores are displayed in an overall ranking.

**Good luck and have fun in the game!**
