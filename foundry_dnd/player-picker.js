// Macro to pick a random player character as a victim from those currently on the screen with health > 0
let charactersWithHealth = canvas.tokens.placeables.filter(token => {
    if (token.actor && token.actor.data.type === "character") {
        let hp = token.actor.data.data.attributes.hp.value;
        return hp > 0;
    }
});

if (charactersWithHealth.length > 0) {
    let randomIndex = Math.floor(Math.random() * charactersWithHealth.length);
    let randomCharacterName = charactersWithHealth[randomIndex].actor.data.name;
    let chatMessageContent = `The victim is: ${randomCharacterName}`;
    ChatMessage.create({
        content: chatMessageContent
    });
} else {
    ui.notifications.error("No healthy player characters found on the screen.");
}
