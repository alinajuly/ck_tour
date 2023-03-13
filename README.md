# API application Tourist portal of Cherkasy region

GeekHub graduation project

## How to install

* Use git clone to clone repository - type in console

```
git clone git@github.com:alinajuly/ck_tour.git
```

* Install Ruby version '3.1.2' use instruction

```
https://www.ruby-lang.org/en/documentation/installation/
```

You may already have Ruby installed on your computer. You can check in console by typing:

```
ruby -v
```

* Install the required gems (Gemfile) in ck_tour derictory (type in console)

```
gem install bundler
```

```
bundle install
```

* Type in console:

```
rails db:create
```

```
rails db:migrate
```

```
rails db:seed
```

## How to open in browser

type in console

```
rails s
```

visit

```
http://localhost:3000
```

## Notice

* After each command `git pull` type in console

```
bundle install
```

```
rails db:migrate
```

## How it works
type in Postman:

1) Authorization:
method POST http://127.0.0.1:3000/auth/login

Params:
- KEY email  VALUE  example@ukr.net
- KEY password VALUE qwerty

### save the token you received!!!

2) GET data:

method GET:

Headers: 
- KEY Authorization   VALUE ```your token```

routes:

list of accommodations: http://127.0.0.1:3000/api/v1/accommodations

show accommodation with rooms: http://127.0.0.1:3000/api/v1/accommodations/:id

show all rooms in accommodation http://127.0.0.1:3000/api/v1/accommodations/1/rooms/

show room http://127.0.0.1:3000/api/v1/accommodations/:id/rooms/:id

3) POST/PUT/PATCH data:

method POST:

Headers:
- KEY Authorization   VALUE ```your token```

new accommodation: http://127.0.0.1:3000/api/v1/accommodations

Params:
- KEY name VALUE ```string```
- KEY description VALUE ```string```
- KEY address VALUE ```string```
- KEY kind VALUE ```string```
- KEY latitude VALUE ```decimal (scale 6)```
- KEY longitude VALUE ```decimal (scale 6)```

new room: http://127.0.0.1:3000/api/v1/accommodations/:id/rooms

Params:
- KEY places VALUE ```integer```
- KEY bed VALUE ```string```
- KEY description VALUE ```string```
- KEY breakfast VALUE ```boolean```
- KEY conditioner VALUE ```boolean```
- KEY price_per_night VALUE ```decimal```

4) DELETE data:

Headers:
- KEY Authorization   VALUE ```your token```

- delete accommodation: http://127.0.0.1:3000/api/v1/accommodations/:id
- delete room: http://127.0.0.1:3000/api/v1/accommodations/:id/rooms/:id
