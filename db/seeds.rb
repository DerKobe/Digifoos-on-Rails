if Rails.env.development?

  user = User.create!(
      email:    'philip.claren@googlemail.com',
      username: 'Kobe',
      password: 'Testest12'
  )

  group = user.groups.create! name: 'Pokercrew'

  players = []

  players << group.players.create!(name: 'Richard')
  players << group.players.create!(name: 'Irenäus')
  players << group.players.create!(name: 'Alexander')
  players << group.players.create!(name: 'Christoph')
  players << group.players.create!(name: 'Philip')
  players << group.players.create!(name: 'Sabine')
  players << group.players.create!(name: 'Christina')
  players << group.players.create!(name: 'Eva')
  players << group.players.create!(name: 'Nadine')
  players << group.players.create!(name: 'Sonja')

  x = 42

  42.times do |i|
    game = group.games.create! status: :finished, created_at: x.days.ago

    score1 = rand(8)
    score2 = case score1
               when 4
                 6
               when 5
                 rand(4)
               when 6
                 4
               when 7
                 5 + rand(1)
               else
                 5
             end

    players.shuffle!
    game.teams.create! players: players[0..1], goals: score1, points: score1 > score2 ? 1 : -1
    game.teams.create! players: players[2..3], goals: score2, points: score1 < score2 ? 1 : -1

    x -= rand(2) if rand(3) == 0
  end

end
