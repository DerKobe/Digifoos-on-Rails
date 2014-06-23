user = User.create!(
    email:    'philip.claren@googlemail.com',
    username: 'philip',
    password: 'Testest12'
)

group1 = user.groups.create! name: 'Super Turnier'
group2 = user.groups.create! name: 'Clash of the Titans'
group3 = user.groups.create! name: 'Gerümpel-Turnier'

r = group1.players.create! name: 'Richard'
i = group1.players.create! name: 'Irek'
a = group1.players.create! name: 'Alex'
c = group1.players.create! name: 'Christoph'
p = group1.players.create! name: 'Philip'

30.times do
  group1.games.create!(
      player1: r,
      player2: i,
      player3: a,
      player4: c
  )
end