function newMessage(email) {
    var chatBox =  document.createElement('div');
    var chatForm = document.createElement('form');
    var chatCorrespondent = document.createElement('input');
    var chatInput = document.createElement('textarea');
    
    chatBox.setAttribute('class', 'chat-box');
    chatBox.setAttribute('id', 'chat-box-' + email);
    
    chatForm.setAttribute('action', '/send_message');
    chatForm.setAttribute('method', 'post');
    chatForm.setAttribute('class', 'chat-box-form');
    chatForm.setAttribute('id', 'chat-box-form-' + email);
    
    chatCorrespondent.setAttribute('type', 'hidden');
    chatCorrespondent.setAttribute('name', 'send_to');
    chatCorrespondent.setAttribute('value', email);
    
    chatInput.setAttribute('class', 'control-form');
    chatInput.setAttribute('name', 'content');
    chatInput.setAttribute('placeholder', 'Type a new message');
    chatInput.setAttribute('id', 'chat-input-' + email)
    
    chatForm.appendChild(chatCorrespondent);
    chatForm.appendChild(chatInput);
    
    chatBox.appendChild(chatForm);
    document.appendChild(chatBox);
}