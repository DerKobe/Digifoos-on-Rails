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

group1.games.create!(
    player1: r,
    player2: i,
    player3: a,
    player4: c,
    goals_team1: 5,
    goals_team2: 3,
    points_team1: 3,
    points_team2: 0
)

group1.games.create!(
    player1: p,
    player2: i,
    player3: a,
    player4: r,
    goals_team1: 5,
    goals_team2: 1,
    points_team1: 3,
    points_team2: 0
)

group1.games.create!(
    player1: c,
    player2: a,
    player3: i,
    player4: p,
    goals_team1: 6,
    goals_team2: 7,
    points_team1: 0,
    points_team2: 3
)

group1.games.create!(
    player1: p,
    player2: c,
    player3: a,
    player4: i,
    goals_team1: 2,
    goals_team2: 5,
    points_team1: 0,
    points_team2: 3
)

group1.games.create!(
    player1: i,
    player2: a,
    player3: r,
    player4: c,
    goals_team1: 6,
    goals_team2: 4,
    points_team1: 3,
    points_team2: 0
)