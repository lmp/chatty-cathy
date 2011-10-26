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
    <div class='messages'></div>
    <form>
      <input type='text' name='message'/> <button id='#send_button'>post message</button>
    </form>
  """
(($) ->
  window.ChatRoomView = Backbone.View.extend(
    tagName: "div"
    className: "messages_frame"
    initialize: (options) ->
      console.log(options)
      @options = options
    render: ->
      $(@el).html Mustache.to_html(templates.messagesPanel, {name: @options.name || "Chat Room"});
      @
  )

  window.ChatView = Backbone.View.extend(
    tag: "div"
    initialize: ->
      @chatRoomView = new ChatRoomView(name: "We like chat");
      @tweetRoomView = new ChatRoomView(name: "Tweets");
    render: ->
      $(@el).html Mustache.to_html(templates.chatPanel)
      $(@el).append(@chatRoomView.render().el);
      $(@el).append(@tweetRoomView.render().el);
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

  window.App = new ChattyCathy();
  Backbone.history.start();
)(jQuery)
