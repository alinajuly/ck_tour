User.create(name: 'Example', email: 'example@ukr.net', password: 'Qwerty_228')

accommodation = Accommodation.create(name: 'Hotel Selena Family Resort',
                       description: 'Цей готель розташований у тихому місці поруч з Дніпром. Інфраструктура готелю налічує літню терасу і ресторан. Гостям пропонується оренда велосипедів, тенісні корти, SUP-борди, прогулянки по Дніпру, рибалка, а також лазні на дровах з виходом на річку, а також можливість користуватися різноманітними спортивними майданчиками',
                       address: 'Дахнівська, 21 Черкаси 19622',
                       kind: 'hotel', phone: '0472545454', email: 'selena@sample.com')

accommodation.coordinates.create(latitude: 49.504189, longitude: 31.962388)

checkin_start_time = Time.parse('2:00 PM')
checkin_end_time = Time.parse('12:00 PM')
checkout_start_time = Time.parse('8:00 AM')
checkout_end_time = Time.parse('1:00 PM')

Facility.create(checkin_start: checkin_start_time,
                checkin_end: checkin_end_time,
                checkout_start: checkout_start_time,
                checkout_end: checkout_end_time,
                credit_card: true,
                free_parking: true,
                wi_fi: true,
                breakfast: true,
                pets: true,
                accommodation_id: accommodation.id)

room = Room.create(places: 2, bed: 'double', name: 'Стандартний двомісний номер', quantity: 6,
              description: 'Стандартний двомісний номер зі спільною ванною кімнатою 16 кв. м Кондиціонер',
              price_per_night: 1690, accommodation_id: accommodation.id)

Amenity.create(conditioner: true, tv: true, refrigerator: true, hair_dryer: true,
               room_id: room.id)

room = Room.create(places: 2, bed: 'double', name: 'Напівлюкс', quantity: 2,
              description: 'Напівлюкс Ванна кімната в номері 32 кв. м Кондиціонер Вид на басейн',
              price_per_night: 2690, accommodation_id: accommodation.id)

Amenity.create(conditioner: true, tv: true, refrigerator: true, hair_dryer: true,
               room_id: room.id)

room = Room.create(places: 2, bed: 'double', name: 'Покращений', quantity: 2,
              description: 'Покращений двомісний номер  Ванна кімната в номері 32 кв. м Кондиціонер ',
              price_per_night: 3290, accommodation_id: accommodation.id)

Amenity.create(conditioner: true, tv: true, refrigerator: true, hair_dryer: true,
               room_id: room.id)

room = Room.create(places: 1, bed: 'one', name: 'Покращений одномісний', quantity: 4,
              description: 'Покращений одномісний номер  Ванна кімната в номері 23 кв. м Кондиціонер ',
              price_per_night: 2790, accommodation_id: accommodation.id)

Amenity.create(conditioner: true, tv: true, refrigerator: true, hair_dryer: true,
               room_id: room.id)

room = Room.create(places: 2, bed: 'double', name: 'Покращений двомісний', quantity: 3,
              description: 'Покращений двомісний номер  Ванна кімната в номері 23 кв. м Кондиціонер ',
              price_per_night: 3290, accommodation_id: accommodation.id)

Amenity.create(conditioner: true, tv: true, refrigerator: true, hair_dryer: true,
               room_id: room.id)

room = Room.create(places: 2, bed: 'twin', name: 'Покращений двомісний', quantity: 4,
              description: 'Покращений двомісний номер   Ванна кімната в номері 23 кв. м Вид Кондиціонер ',
              price_per_night: 3290, accommodation_id: accommodation.id)

Amenity.create(conditioner: true, tv: true, refrigerator: true, hair_dryer: true,
               room_id: room.id)

room = Room.create(places: 2, bed: 'double', name: 'Бунгало', quantity: 5,
              description: 'Бунгало 40 кв. м Вид на сад Кондиціонер ',
              price_per_night: 3990, accommodation_id: accommodation.id)

Amenity.create(conditioner: true, tv: true, refrigerator: true, hair_dryer: true, nice_view: true, inclusive: true,
               room_id: room.id)

room = Room.create(places: 3, bed: 'double+one', name: 'Сімейний люкс', quantity: 5,
              description: 'Сімейний люкс 40 кв. м Вид Кондиціонер ',
              price_per_night: 4490, accommodation_id: accommodation.id)

Amenity.create(conditioner: true, tv: true, refrigerator: true, hair_dryer: true, nice_view: true, inclusive: true,
               room_id: room.id)

accommodation = Accommodation.create(name: 'Dragomir Apartments',
                                     description: 'Комплекс апартаментів "Драгомир" розташований в Черкасах. В комплексі гостям пропонують індивідуально мебльовані апартаменти та номери-студіо з кондиціонерами. Гостям надається безкоштовний Wi-Fi',
                                     address: 'Митницька, 16 Черкаси 18015',
                                     kind: 'apartment', phone: '0472454545', email: 'dragomir@sample.com')

accommodation.coordinates.create(latitude: 49.437345, longitude: 32.069233)

checkin_start_time = Time.parse('2:00 PM')
checkin_end_time = Time.parse('10:00 PM')
checkout_start_time = Time.parse('9:00 AM')
checkout_end_time = Time.parse('1:00 PM')

Facility.create(checkin_start: checkin_start_time,
                checkin_end: checkin_end_time,
                checkout_start: checkout_start_time,
                checkout_end: checkout_end_time,
                credit_card: true,
                wi_fi: true,
                accommodation_id: accommodation.id)

room = Room.create(places: 2, bed: 'double', name: 'Студіо', quantity: 1,
            description: 'Апартаменти-студіо',
            price_per_night: 700, accommodation_id: accommodation.id)

Amenity.create(conditioner: true, tv: true, refrigerator: true, hair_dryer: true, kettle: true, mv_owen: true,
               room_id: room.id)

room = Room.create(places: 2, bed: 'double', name: 'Покращений', quantity: 1,
            description: 'Покращені апартаменти ',
            price_per_night: 900, accommodation_id: accommodation.id)

Amenity.create(conditioner: true, tv: true, refrigerator: true, hair_dryer: true, kettle: true, mv_owen: true,
               room_id: room.id)

room = Room.create(places: 4, bed: 'double+double', name: 'Студіо', quantity: 1,
            description: 'Апартаменти-студіо ',
            price_per_night: 800, accommodation_id: accommodation.id)

Amenity.create(conditioner: true, tv: true, refrigerator: true, hair_dryer: true, kettle: true, mv_owen: true,
               room_id: room.id)
