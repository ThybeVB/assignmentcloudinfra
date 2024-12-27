const express = require("express");
const mongoose = require("mongoose");
const bodyParser = require("body-parser");
const path = require("path");

const app = express();

app.use(bodyParser.json());

const mongoUri = process.env.MONGO_URI || "mongodb://localhost/db/reminders";
mongoose.connect(mongoUri, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
});

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

app.get("/reminders", async (req, res) => {
    try {
        const reminders = await Reminder.find();
        res.json(reminders);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

app.post("/reminders", async (req, res) => {
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

app.put("/reminders/:id", async (req, res) => {
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

app.delete("/reminders/:id", async (req, res) => {
    try {
        const reminder = await Reminder.findById(req.params.id);
        if (!reminder) return res.status(404).json({ message: "Reminder not found" });
        await Reminder.deleteOne({ _id: req.params.id });
        res.status(200);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});
