# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

game_1 = 
  Game.find_or_create_by(
    player_name: "Bhargav Thummar",
  )

frames_1 = 
  [
    {
      slot_1_points: 3,
      slot_2_points: 4
    },
    {
      slot_1_points: 10,
      slot_2_points: 0
    },
    {
      slot_1_points: 3,
      slot_2_points: 4
    },
    {
      slot_1_points: 3,
      slot_2_points: 4
    },
    {
      slot_1_points: 3,
      slot_2_points: 4
    },
    {
      slot_1_points: 3,
      slot_2_points: 4
    },
    {
      slot_1_points: 3,
      slot_2_points: 4
    },
    {
      slot_1_points: 3,
      slot_2_points: 4
    },
    {
      slot_1_points: 3,
      slot_2_points: 4
    },
    {
      slot_1_points: 2,
      status: :active
    }
  ]

# create frames at once
game_1.frames.create(frames_1)


game_2 = 
  Game.find_or_create_by(
    player_name: "Simform Solutions",
  )

frames_2 = 
  [
    {
      slot_1_points: 3,
      slot_2_points: 4
    },
    {
      slot_1_points: 10,
      slot_2_points: 0
    },
    {
      slot_1_points: 3,
      slot_2_points: 4
    },
    {
      slot_1_points: 3,
      slot_2_points: 4
    },
    {
      slot_1_points: 3,
      slot_2_points: 4
    },
    {
      slot_1_points: 3,
      slot_2_points: 4
    },
    {
      slot_1_points: 3,
      slot_2_points: 4
    },
    {
      slot_1_points: 3,
      slot_2_points: 4
    },
    {
      slot_1_points: 3,
      slot_2_points: 4
    },
    {
      slot_1_points: 3,
      slot_2_points: 7
    }
  ]

# create frames at once
game_2.frames.create(frames_2)