
class Seed
    def self.seed_data
        10.times do
            Tweet.create({content: Faker::TvShows::MichaelScott.quote, author: Author.create(name: 'Michael Scott')})
        end

        5.times do
            Tweet.create({content: Faker::Quote.yoda, author: Author.create(name: 'Yoda')})
        end

        5.times do
            Tweet.create({content: Faker::Quote.matz, author: Author.create(name: 'Matz')})
        end
    end
end