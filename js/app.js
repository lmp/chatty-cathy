(function() {
  var templates;
  templates = {
    homePage: "Welcome to chatty cathy. Click <a href='#chat'>here</a> to chat.",
    chatPanel: "<h1>Chatty Cathy Chat Room</h1>\n<div style='clear: both'><a href='#'>Go home, chatty cathy</a></div>",
    messagesPanel: "<h2>{{name}}</h2>\n<div class='messages'></div>\n<form>\n  <input type='text' name='message'/> <button id='#send_button'>post message</button>\n</form>"
  };
  (function($) {
    window.ChatRoomView = Backbone.View.extend({
      tagName: "div",
      className: "messages_frame",
      initialize: function(options) {
        console.log(options);
        return this.options = options;
      },
      render: function() {
        $(this.el).html(Mustache.to_html(templates.messagesPanel, {
          name: this.options.name || "Chat Room"
        }));
        return this;
      }
    });
    window.ChatView = Backbone.View.extend({
      tag: "div",
      initialize: function() {
        this.chatRoomView = new ChatRoomView({
          name: "We like chat"
        });
        return this.tweetRoomView = new ChatRoomView({
          name: "Tweets"
        });
      },
      render: function() {
        $(this.el).html(Mustache.to_html(templates.chatPanel));
        $(this.el).append(this.chatRoomView.render().el);
        $(this.el).append(this.tweetRoomView.render().el);
        return this;
      }
    });
    window.HomeView = Backbone.View.extend({
      tag: "div",
      initialize: function() {},
      render: function() {
        $(this.el).html(Mustache.to_html(templates.homePage));
        return this;
      }
    });
    window.ChattyCathy = Backbone.Router.extend({
      routes: {
        '': 'home',
        'chat': 'chat'
      },
      initialize: function() {},
      home: function() {
        return $('#container').empty().append(new HomeView().render().el);
      },
      chat: function() {
        return $('#container').empty().append(new ChatView().render().el);
      }
    });
    window.App = new ChattyCathy();
    return Backbone.history.start();
  })(jQuery);
}).call(this);
