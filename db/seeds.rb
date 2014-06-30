user = User.create!(
    email:    'philip.claren@googlemail.com',
    username: 'Kobe',
    password: 'philip.claren@googlemail.com'
)

group = user.groups.create! name: 'Super Turnier'

players = []

players << group.players.create!(name: 'Richard')
players << group.players.create!(name: 'Irenäus')
players << group.players.create!(name: 'Alexander')
players << group.players.create!(name: 'Christoph')
players << group.players.create!(name: 'Philip')

100.times do |i|
  game = group.games.create! status: :finished

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

  #print "#{i}:" if i % 100 == 0
end
