User.create(name: 'Example', email: 'example@ukr.net', password: 'Qwerty_228')

accommodation = Accommodation.create(name: 'Hotel Selena Family Resort',
                       description: 'Цей готель розташований у тихому місці поруч з Дніпром. Інфраструктура готелю налічує літню терасу і ресторан. Гостям пропонується оренда велосипедів, тенісні корти, SUP-борди, прогулянки по Дніпру, рибалка, а також лазні на дровах з виходом на річку, а також можливість користуватися різноманітними спортивними майданчиками',
                       address: 'Дахнівська, 21 Черкаси 19622',
                       kind: 'hotel', phone: '0472545454')

accommodation.coordinates.create(latitude: 49.504189, longitude: 31.962388)

6.times do
  Room.create(places: 2, bed: 'double',
              description: 'Стандартний двомісний номер зі спільною ванною кімнатою 16 кв. м Кондиціонер',
              breakfast: true, conditioner: false, price_per_night: 1690, accommodation_id: accommodation.id)
end

2.times do
  Room.create(places: 2, bed: 'double',
              description: 'Напівлюкс Ванна кімната в номері 32 кв. м Кондиціонер Вид на басейн',
              breakfast: true, conditioner: false, price_per_night: 2690, accommodation_id: accommodation.id)
end

2.times do
  Room.create(places: 2, bed: 'double',
              description: 'Покращений двомісний номер  Ванна кімната в номері 32 кв. м Кондиціонер ',
              breakfast: true, conditioner: false, price_per_night: 3290, accommodation_id: accommodation.id)
end

3.times do
  Room.create(places: 1, bed: 'one',
              description: 'Покращений одномісний номер  Ванна кімната в номері 23 кв. м Кондиціонер ',
              breakfast: true, conditioner: true, price_per_night: 2790, accommodation_id: accommodation.id)
end

3.times do
  Room.create(places: 2, bed: 'double',
              description: 'Покращений двомісний номер  Ванна кімната в номері 23 кв. м Кондиціонер ',
              breakfast: true, conditioner: true , price_per_night: 3290, accommodation_id: accommodation.id)
end

4.times do
  Room.create(places: 2, bed: 'twin',
              description: 'Покращений двомісний номер   Ванна кімната в номері 23 кв. м Вид Кондиціонер ',
              breakfast: true, conditioner: false, price_per_night: 3290, accommodation_id: accommodation.id)
end

5.times do
  Room.create(places: 2, bed: 'double',
              description: 'Бунгало 40 кв. м Вид на сад Кондиціонер ',
              breakfast: true, conditioner: false, price_per_night: 3990, accommodation_id: accommodation.id)
end

5.times do
  Room.create(places: 3, bed: 'double+one',
              description: 'Сімейний люкс 40 кв. м Вид Кондиціонер ',
              breakfast: true, conditioner: true, price_per_night: 4490, accommodation_id: accommodation.id)
end

accommodation = Accommodation.create(name: 'Dragomir Apartments',
                                     description: 'Комплекс апартаментів "Драгомир" розташований в Черкасах. В комплексі гостям пропонують індивідуально мебльовані апартаменти та номери-студіо з кондиціонерами. Гостям надається безкоштовний Wi-Fi',
                                     address: 'Митницька, 16 Черкаси 18015',
                                     kind: 'apartment', phone: '0472454545')

accommodation.coordinates.create(latitude: 49.437345, longitude: 32.069233)

Room.create(places: 2, bed: 'double',
            description: 'Апартаменти-студіо',
            breakfast: false, conditioner: true, price_per_night: 700, accommodation_id: accommodation.id)

Room.create(places: 2, bed: 'double',
            description: 'Покращені апартаменти ',
            breakfast: false, conditioner: true, price_per_night: 900, accommodation_id: accommodation.id)

Room.create(places: 4, bed: 'double+double',
            description: 'Апартаменти-студіо ',
            breakfast: false, conditioner: true, price_per_night: 800, accommodation_id: accommodation.id)


