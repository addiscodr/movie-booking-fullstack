require('dotenv').config();

const express = require('express');
const Stripe = require('stripe');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

const stripe = Stripe(process.env.STRIPE_SECRET_KEY);

app.get('/', (req, res) => {
  res.json({ success: true, message: 'Movie Booking Stripe Backend Running' });
});

app.post('/create-payment-intent', async (req, res) => {
  try {
    const { amount } = req.body;

    const paymentIntent = await stripe.paymentIntents.create({
      amount,
      currency: 'usd',
    });

    res.send({
      clientSecret: paymentIntent.client_secret,
    });
  } catch (error) {
    res.status(400).send({
      error: error.message,
    });
  }
});

const PORT = process.env.PORT || 3030;

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
