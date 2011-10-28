templates =
  homePage: """
    Welcome to chatty cathy. Click <a href='#chat'>here</a> to chat.
  """
  chatPanel: """
    <h1>Chatty Cathy Chat Room</h1>
    <div style='clear: both'><a href='#'>Go home, chatty cathy</a></div>
  """
  messagesPanel: """
    <h2>{{name}}</h2>
    <form>
      <input type='text' name='message'/> <input type='submit' id='send_button' value='post message'/>
    </form>
    <div class='messages'></div>
  """
  message: """
    <div class='message'>
      <span class='message_body'>{{message}}</span>
      <span class='timestamp'>- {{created_at}}</span>
    </div>
  """
(($) ->
  window.Message = Backbone.Model.extend(
    type: "message"
  )
  window.MessagesList = Backbone.Collection.extend(
    view: "allMessages"
    doreduce: false
    model: Message
    comparator: (todo) ->
      new Date(todo.get("created_at"))
  )

  window.ChatRoomView = Backbone.View.extend(
    tagName: "div"
    className: "messages_frame"
    events:
      "submit form": 'add'
    initialize: (options) ->
      @options = options
      @messages = new MessagesList()
      window.messages = @messages

      @messages.bind('add', (m)=> @renderMessage(m));
      @messages.bind('reset', => @renderMessages());
      @messages.fetch()
    add: (e)->
      e.preventDefault()
      msg = $(@el).find("input[name=message]").val()
      @messages.create(created_at: new Date(), message: msg)
      $(@el).find("form")[0].reset();
    renderMessage: (message) ->
      $(@messages_el).prepend Mustache.to_html(templates.message, message.toJSON())
    renderMessages: (message) ->
      @messages_el.empty();
      @messages.each (m) => @renderMessage(m)
    render: ->
      console.log("render");
      $(@el).html Mustache.to_html(templates.messagesPanel, {name: @options.name || "Chat Room"});
      @messages_el = $(@el).find('.messages')
      console.log(@messages_el);
      @
  )

  window.ChatView = Backbone.View.extend(
    tag: "div"
    initialize: ->
      @chatRoomView = new ChatRoomView(name: "We like chat");
      # @tweetRoomView = new ChatRoomView(name: "Tweets");
    render: ->
      $(@el).html Mustache.to_html(templates.chatPanel)
      $(@el).append(@chatRoomView.render().el);
      # $(@el).append(@tweetRoomView.render().el);
      @
  )
  window.HomeView = Backbone.View.extend(
    tag: "div"
    initialize: ->
    render: ->
      $(@el).html Mustache.to_html(templates.homePage)
      @
  )

  window.ChattyCathy = Backbone.Router.extend(
    routes:
      '': 'home'
      'chat': 'chat'
    initialize: ->
    home: ->
      $('#container').empty().append(new HomeView().render().el)
    chat: ->
      $('#container').empty().append(new ChatView().render().el)
  )

  Backbone.couch.databaseName = "chatty-cathy"
  Backbone.couch.ddocName = "chatty-cathy"
  Backbone.couch.enableChangesFeed = true
  Backbone.couch.ddocChange((ddocName) ->
    if (console && console.log)
      console.log("current ddoc: '" + ddocName + "' changed")
      console.log("restarting...")
    window.location.reload()
  )
  window.App = new ChattyCathy()
  Backbone.history.start()
)(jQuery)
