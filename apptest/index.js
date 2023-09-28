const express = require('express')
const Sequelize = require('sequelize')
const app = express()
const port = 80
app.use(express.json());

const sequelize = new Sequelize('postgres', 'user12345678', 'user12345678', {
    host: 'database-service',
    dialect: 'postgres'
  //  ssl: true
  });


//Invoke the Sequelize object and pass in the database connection string to its constructor by doing the following:
//const sequelize = new Sequelize('postgres://user12345678:pass12345678@database-2.ceoaj7zkmjj1.us-west-2.rds.amazonaws.com:5432/DBNAMEPOSTGRES')


//To test if the connection with the database is successful we can write the following code:
sequelize
.authenticate()
.then(() => {
console.log('Connection has been established successfully.');
})
.catch(err => {
console.error('Unable to connect to the database:', err);
});

//Model our User table:
const User = sequelize.define('user', {
// attributes
firstName: {
type: Sequelize.STRING,
allowNull: false
},
lastName: {
type: Sequelize.STRING
// allowNull defaults to true
}
}, {
// options
});

// Note: using `force: true` will drop the table if it already exists
User.sync({ force: true }) // Now the `users` table in the database corresponds to the model definition
app.get('/', (req, res) => res.json({ message: 'Denzel APP - Version update 2023' }))

//Add a POST endpoint that contains the user in the request body:
app.post('/user', async (req, res) => {
try {
const newUser = new User(req.body)
await newUser.save()
res.json({ user: newUser }) // Returns the new user that is created in the database
} catch(error) {
console.error(error)
}
})
//This stores the user in the database, so let’s deﬁne an endpoint to retrieve the user from the database.
app.get('/user/:userId', async (req, res) => {
const userId = req.params.userId
try {
const user = await User.findAll({
where: {
id: userId
}
}
)
res.json({ user })
} catch(error) {
console.error(error)
}
})
app.listen(port, () => console.log(`Example app listening on port ${port}!`))


