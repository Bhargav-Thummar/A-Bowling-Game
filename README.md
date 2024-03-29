# A Bowling Game
##### This is a simple bowling game score calulator. It is build with ruby on rails 7. This application provides feature to start game and add scores of each bowl. The best part is this application manage everything internally including frames, slots and it's score. user only have to add score value without worrying about frame & slot number.


## Features
- Ruby (Version: 3.2.0)
- Ruby on Rails (Version: 7.0.8)
- Use acts_as_list gem to maintain position/frame-number 
- Registered game will be stored in session so user don't need to pass game in each API request
- Frames will create & terminate automatically based on rules of game so user don't need to change and pass frame in each API request
- Integrate error handling module to rescue from all type of standard error and present it in readable format


## Setup application
To run application locally, follow these steps:

- Clone the Repository
- Install Ruby 3.2.0
- Install Postgresql and setup username and password in config/database.yml file
- Run following commands from terminal
```sh
bundle install
rails db:create
rails db:migrate

# Start the server
rails s
```

#### OR
- Run following command from terminal
```sh
./bin/setup

# Start the server
rails s
```


## API Endpoints
Here is the list of APIs

| Method   | URL                                      | Description                              |
| -------- | ---------------------------------------- | ---------------------------------------- |
| `GET`    | `/v1/games`                             | To retrieve all games with score of each frames.                     |
| `POST`   | `/v1/games`                             | To start new game.                       |
| `POST`    | `/v1/games/add_score`                          | To add score.                       |
| `GET`  | `/v1/games/get_score_card`                          | To get recent game score 

## How to Use

- Now go to http://localhost:3000, and we should see the Rails boot screen.

- Please import attached API collection into the postman to test the APIs [a_bowling_game.postman_collection.json](a_bowling_game.postman_collection.json)