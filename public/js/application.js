function newMessage(email) {
    var chatDiv =  document.createElement('div');
    var chatBox =  document.createElement('div');
    var chatHeader = document.createElement('header');
    var chatMessages = document.createElement('section');
    var chatForm = document.createElement('form');
    var chatCorrespondent = document.createElement('input');
    var chatInput = document.createElement('textarea');
    
    chatDiv.setAttribute('class', 'col-3');
    
    chatBox.setAttribute('class', 'chat-box');
    chatBox.setAttribute('id', 'chat-box-' + email);
    
    chatHeader.setAttribute('class', 'chat-header');
    chatHeader
    .innerHTML = '<span>' + email + '</span>' +
    `<span class="chat-close float-right" onclick="closeChat(this)" id="chat-close-` + email + `">&times;</span>`;
    
    chatMessages.setAttribute('class', 'chat-messages-container');
    chatMessages.setAttribute('id', 'chat-messages-container-' + email);
    
    chatForm.setAttribute('action', '/send_message');
    chatForm.setAttribute('method', 'post');
    chatForm.setAttribute('class', 'chat-box-form');
    chatForm.setAttribute('id', 'chat-box-form-' + email);
    chatForm.setAttribute('data-remote', 'true');
    
    chatCorrespondent.setAttribute('type', 'hidden');
    chatCorrespondent.setAttribute('name', 'recipient_email');
    chatCorrespondent.setAttribute('value', email);
    
    chatInput.setAttribute('class', 'control-form chat-input');
    chatInput.setAttribute('name', 'content');
    chatInput.setAttribute('placeholder', 'Type a new message');
    chatInput.setAttribute('id', 'chat-input-' + email)
    chatInput.setAttribute('autocomplete', 'off');
    chatInput.setAttribute('autofocus', 'true');
    chatInput.setAttribute('onkeyup', 'awaitSubmission(event, this)');
    
    chatForm.appendChild(chatCorrespondent);
    chatForm.appendChild(chatInput);
    
    chatBox.appendChild(chatHeader);
    chatBox.appendChild(chatMessages);
    chatBox.appendChild(chatForm);
    
    chatDiv.appendChild(chatBox);
    
    document.querySelector('#chat-box-container').appendChild(chatDiv);
}

function closeChat(elem) {
    var id = elem.id.split('chat-close-')[1];
    document.getElementById('chat-box-' + id).remove();
}

function awaitSubmission(e, elem) {
    var text = elem.value;
    var id = elem.id.split('chat-input-')[1];
    var form = document.getElementById('chat-box-form-' + id);
    var messagesContainer = document.getElementById('chat-messages-container-' + id);
    var messageBubble = document.createElement('div');
    
    messageBubble.setAttribute('class', 'message-bubble');
    messageBubble.innerHTML = text;
    
    if (e.keyCode == 13) {
        $.post('/send_message', { content: text, recipient_email: id });
        form.reset();
        messagesContainer.append(messageBubble);
    }
}

function showNewUpdateForm() {
    $(this).hide();
    $('#new-update-form').show();
}