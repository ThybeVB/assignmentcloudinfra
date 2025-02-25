const express = require("express");
const mongoose = require("mongoose");
const bodyParser = require("body-parser");
const path = require("path");

const app = express();

app.use(bodyParser.json());

// Connection URI
const mongoUri = process.env.MONGO_URI || "mongodb://localhost:27017/reminders";

const connectWithRetry = async () => {
  try {
    await mongoose.connect(mongoUri, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log("Connected to MongoDB");
  } catch (err) {
    console.error("Failed to connect to MongoDB - retrying in 5 seconds", err);
    setTimeout(connectWithRetry, 5000);
  }
};

connectWithRetry();

const db = mongoose.connection;
db.on("error", console.error.bind(console, "connection error:"));
db.once("open", () => {
    console.log("Connected to MongoDB");
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

const Reminder = require("./models/Reminder");

app.get("/api/reminders", async (req, res) => {
    try {
        const reminders = await Reminder.find();
        res.json(reminders);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

app.post("/api/reminders", async (req, res) => {
    const reminder = new Reminder({
        title: req.body.title,
        description: req.body.description,
        date: req.body.date,
    });

    try {
        const newReminder = await reminder.save();
        res.status(201).json(newReminder);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

app.put("/api/reminders/:id", async (req, res) => {
    try {
        const reminder = await Reminder.findById(req.params.id);
        if (!reminder) return res.status(404).json({ message: "Reminder not found" });

        reminder.title = req.body.title || reminder.title;
        reminder.description = req.body.description || reminder.description;
        reminder.date = req.body.date || reminder.date;

        const updatedReminder = await reminder.save();
        res.json(updatedReminder);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

app.delete("/api/reminders/:id", async (req, res) => {
    try {
        const reminder = await Reminder.findById(req.params.id);
        if (!reminder) return res.status(404).json({ message: "Reminder not found" });
        await Reminder.deleteOne({ _id: req.params.id });
        res.status(200);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});
