attraction = Attraction.create(title: 'Долина троянд', description: 'Долина Троянд — парк-пам\'ятка садово-паркового мистецтва
в Україні розміщений неподалік від центральної частини міста Черкаси, при вулиці
Гагаріна, на березі Кременчуцького водосховища, від якого відгороджений лісосмугою.
Поруч з парком розміщений меморіальний комплекс Пагорб Слави. У парку є декілька
фонтанів з міні-озерами, облаштовані алеї з лавочками та ліхтарями, а також
невеликий пляж на березі Дніпра. У 2012 році в парку збудований сонячний годинник
у вигляді журавля та дванадцяти металевих кованих стільців. «Долина Троянд»
традиційно використовується для святкування дня міста. Тут у липні 2019 року
відбувся уже ХІ етнічний фестиваль «Трипільські зорі».')

attraction.coordinates.create(latitude: 49.450941, longitude: 32.065144)
attraction.toponyms.create(locality: 'Черкаси')

attraction = Attraction.create(title: 'Блакитний палац', description: 'Блакитним палацом жителі Черкас називають
будівлю колишнього готелю «Слов\'янський», що побудований на замовлення одного з
найвідоміших у свій час підприємців Скорини за проектом архітектора Владислава
Городецького в кінці XIX століття. Місце розташування: на розі вул. Хрещатик —
О. Дашковича. Блакитний палац побудовано з елементами таких стилів, як класицизм
і модерн, а також має запозичення з будівель середньовічної близькосхідної
архітектури')

attraction.coordinates.create(latitude: 49.445000, longitude: 32.063333)
attraction.toponyms.create(locality: 'Черкаси')

attraction = Attraction.create(title: 'парк Софіївка', description: 'Численним відвідувачам дендропарк «Софіївка» відомий як
туристична перлина України, музей садово-паркового мистецтва, місце, де можна
поринути у казковий романтичний світ природи, краси і кохання… Національний
дендрологічний парк „Софіївка” – одне з найвидатніших творінь світового садово-
паркового мистецтва кінця ХVІІІ – першої половини ХІХ ст. Парк розкинувся на
площі майже 180 га на узбіччі старовинного міста Умань')

attraction.coordinates.create(latitude: 48.763056, longitude: 30.222500)
attraction.toponyms.create(locality: 'Умань')

attraction = Attraction.create(title: 'Буцький каньйон', description: 'каньйон в межах смт Буки Уманського району, на річці
Гірський Тікич. Утворений у протерозойських гранітах, вік яких оцінюється у 2
мільярди років. Каньйон починається за 800 м нижче від греблі колишньої Буцької
ГЕС. Неподалік від греблі розташований водоспад Вир. Каньйон являє собою
оригінальний скелястий берег з виступами сірого граніту, заввишки близько
30 метрів. Довжина каньйону бл. 2,5 км, ширина — 80 м. Площа, що підлягає
природоохоронним заходам — 80 га. Буцький каньйон — рекреаційна зона, також
каньйон пасує для скелелазіння, сплавів на байдарках')

attraction.coordinates.create(latitude: 49.090060, longitude: 30.398530)
attraction.toponyms.create(locality: 'Буки')

attraction = Attraction.create(title: 'заказник Білосніжний', description: 'ботанічний заказник місцевого значення в межах
Національного природного парку "Холодний Яр". Холодний Яр – сакральна місцина
українського нескорного духу, що має неабияке історичне та культурне значення,
проте передовсім – це реліктовий лісовий масив, невичерпне джерело інформації для
біологів та екологів, багате на рідкісних представників флори.
Одне з природних багатств Холодного Яру – величезний килим первоцвітів – поля квітучого підсніжника складчастого')

attraction.coordinates.create(latitude: 49.160957, longitude: 32.245732)
attraction.toponyms.create(locality: 'Холодний Яр')

user = User.create(name: 'partner', email: 'partner@test.com', password: 'Partner123!', role: 1)

accommodation = Accommodation.create(name: 'Hotel Selena Family Resort',
                       description: 'Цей готель розташований у тихому місці поруч з Дніпром. Інфраструктура готелю налічує літню терасу і ресторан. Гостям пропонується оренда велосипедів, тенісні корти, SUP-борди, прогулянки по Дніпру, рибалка, а також лазні на дровах з виходом на річку, а також можливість користуватися різноманітними спортивними майданчиками',
                       address: 'Дахнівська, 21 Черкаси 19622',
                       kind: 'hotel', phone: '0472545454', email: 'selena@sample.com', user_id: user.id)

accommodation.coordinates.create(latitude: 49.504189, longitude: 31.962388)
accommodation.toponyms.create(locality: 'Черкаси')

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
                                     kind: 'apartment', phone: '0472454545', email: 'dragomir@sample.com', user_id: user.id)

accommodation.coordinates.create(latitude: 49.437345, longitude: 32.069233)
accommodation.toponyms.create(locality: 'Черкаси')

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

user = User.create(name: 'partner2', email: 'partner2@test.com', password: 'Partner1234!', role: 1)

accommodation = Accommodation.create(name: 'Guest House',
                                     description: 'Guest house offers accommodation in Uman, 2.4 km from Singing fountains in Uman and 700 metres from Grave of Tsadik Nachman. The accommodation is 1.4 km from Sofiyivka Park, and guests benefit from private parking available on site and free WiFi.',
                                     address: 'Комарницького, 21 Умань 20300',
                                     kind: 'apartment', phone: '0472555555', email: 'uman_best@sample.com', user_id: user.id)

accommodation.coordinates.create(latitude: 48.751585, longitude: 30.234364)
accommodation.toponyms.create(locality: 'Умань')

checkin_start_time = Time.parse('2:00 PM')
checkin_end_time = Time.parse('10:00 PM')
checkout_start_time = Time.parse('9:00 AM')
checkout_end_time = Time.parse('1:00 PM')

Facility.create(checkin_start: checkin_start_time,
                checkin_end: checkin_end_time,
                checkout_start: checkout_start_time,
                checkout_end: checkout_end_time,
                wi_fi: true,
                accommodation_id: accommodation.id)

room = Room.create(places: 9, bed: '4 twin + one', name: 'Guest House', quantity: 1,
                   description: '3-кімнатні апартаменти',
                   price_per_night: 1625, accommodation_id: accommodation.id)

Amenity.create(conditioner: true, tv: true, refrigerator: true, hair_dryer: true, kettle: true, mv_owen: true,
               room_id: room.id)

User.create(name: 'tourist', email: 'tourist@test.com', password: 'User123!', role: 0)
User.create(name: 'admin', email: 'admin@test.com', password: 'Admin123!', role: 2)
