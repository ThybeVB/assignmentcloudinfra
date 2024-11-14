const apiUrl = "/api/reminders";

function loadReminders() {
    $.ajax({
        url: apiUrl,
        method: "GET",
        success: function (reminders) {
            const tbody = $("#reminders-table tbody");
            tbody.empty();
            reminders.forEach((reminder) => {
                tbody.append(`
                    <tr data-id="${reminder._id}">
                        <td>${reminder.title}</td>
                        <td>${reminder.description}</td>
                        <td>${new Date(reminder.date).toLocaleDateString()}</td>
                        <td>
                            <button class="btn btn-sm btn-info edit-btn">Edit</button>
                            <button class="btn btn-sm btn-danger delete-btn">Delete</button>
                        </td>
                    </tr>
                `);
            });
        },
        error: function () {
            alert("Could not load reminders.");
        },
    });
}

function addReminderHandler(e) {
    e.preventDefault();
    const title = $("#title").val();
    const description = $("#description").val();
    const date = $("#date").val();

    $.ajax({
        url: apiUrl,
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify({ title, description, date }),
        success: function () {
            $("#reminder-form")[0].reset();
            loadReminders();
        },
        error: function () {
            alert("Could not add reminder.");
        },
    });
}

$("#reminder-form").submit(addReminderHandler);

// Edit a reminder
$(document).on("click", ".edit-btn", function () {
    const row = $(this).closest("tr");
    const id = row.data("id");
    const title = row.find("td:eq(0)").text();
    const description = row.find("td:eq(1)").text();
    const date = row.find("td:eq(2)").text();

    $("#title").val(title);
    $("#description").val(description);
    $("#date").val(new Date(date).toISOString().split("T")[0]);

    $("#reminder-form")
        .off("submit")
        .submit(function (e) {
            e.preventDefault();

            $.ajax({
                url: `${apiUrl}/${id}`,
                method: "PUT",
                contentType: "application/json",
                data: JSON.stringify({
                    title: $("#title").val(),
                    description: $("#description").val(),
                    date: $("#date").val(),
                }),
                success: function () {
                    $("#reminder-form")[0].reset();
                    loadReminders();
                    $("#reminder-form").off("submit").submit(addReminderHandler);
                },
                error: function () {
                    alert("Could not update reminder.");
                },
            });
        });
});

$(document).on("click", ".delete-btn", function () {
    const row = $(this).closest("tr");
    const id = row.data("id");

    $.ajax({
        url: `${apiUrl}/${id}`,
        method: "DELETE",
        success: function () {
            row.remove();
        },
        error: function () {
            alert("Could not delete reminder.");
        },
    });
});

loadReminders();
