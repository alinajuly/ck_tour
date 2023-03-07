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

* After each command `git pull` please type in console

```
bundle install
```

```
rails db:migrate
```
