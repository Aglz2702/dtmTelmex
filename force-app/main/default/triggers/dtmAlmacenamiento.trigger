trigger dtmAlmacenamiento on QuoteLineItem (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        dtmAlmacenamientoHandler.handleAfterUpdate(Trigger.new);
    }
}