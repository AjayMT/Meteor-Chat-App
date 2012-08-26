root = global ? window
Users = new root.Meteor.Collection("users")
Messages = new root.Meteor.Collection("msgs")

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
  
  root.Template.chatSection.msgs = ->
    root.Messages.find({})
  
  root.Template.chatSection.events =
    'click input.postMsgB': ->
      msg = document.getElementsByName("msg")[0].value
      from = root.Users.findOne(root.Session.get("lgin_usr")).usrn
      root.Messages.insert({ msg: msg, from: from })
