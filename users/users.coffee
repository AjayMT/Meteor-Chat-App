root = global ? window
Users = new root.Meteor.Collection("users")
Messages = new root.Meteor.Collection("msgs")
Groups = new root.Meteor.Collection("groups")

if root.Meteor.is_client
  root.Template.loginform.events =
    'click input.lgn': ->
      usrn = document.getElementsByName("username")[0].value
      pass = document.getElementsByName("password")[0].value
      usr = root.Users.findOne({ usrn: usrn })
      root.Users.insert({ usrn: usrn, pass: pass }) unless usr?
      usr = root.Users.findOne({ usrn: usrn, pass: pass })
      root.Session.set("lgin_usr", usr._id) if usr?
  
  root.Template.main.usrname = ->
    usr = root.Users.findOne(root.Session.get("lgin_usr"))
    usr.usrn if usr?
  
  root.Template.main.events =
    'click input.lgout': ->
      root.Session.set("lgin_usr", "")
    'click input.cg': ->
      gname = document.getElementsByName("gname")[0].value
      root.Groups.insert({ name: gname })
  
  root.Template.chatSection.msgs = ->
    group = root.Groups.findOne(root.Session.get("current_group"))
    if group? then root.Messages.find({ group: group.name })
  
  root.Template.chatSection.events =
    'click input.postMsgB': ->
      msg = document.getElementsByName("msg")[0].value
      from = root.Users.findOne(root.Session.get("lgin_usr")).usrn
      group = root.Groups.findOne(root.Session.get("current_group"))
      root.Messages.insert({ msg: msg, from: from, group: group.name }) if group? and msg
  
  root.Template.group.current = ->
    if root.Session.equals("current_group", @_id) then "current" else ""
  
  root.Template.group.events =
    'click': ->
      root.Session.set("current_group", @_id)
  
  root.Template.main.groups = ->
    root.Groups.find({}, { sort: { name: 1 } })

if root.Meteor.is_server
  Meteor.startup(
    ->
      # code to run on server startup
  )
