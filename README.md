# API application Tourist portal of Cherkasy region

GeekHub graduation project by [Alina Cheriapkina] (https://github.com/alinajuly “Alina Cheriapkina”) and [Serge Krynytsia] (https://github.com/Haidamac “Serge Krynytsia”)

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

## How to use

type in console

```
rails s
```

visit

```
http://localhost:3000
```

## Open Swagger UI in browser:
```ruby
http://localhost:3000/api-docs/index.html
```

## Visit to see project with front-end and design

[cktour project] (https://tour-project-frontend.vercel.app/ “cktour project”)
