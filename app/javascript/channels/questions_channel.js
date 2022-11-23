import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  if (this.subscription) {
    consumer.subscriptions.remove(this.subscription)
  }

  if (document.querySelector('.question_block_main')){
    var subscription = consumer.subscriptions.create("QuestionsChannel", {
      connected() {
        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        $('.question_block_main').append('<p><a href="/questions/' + data.id + '">' + data.title +'</a></p>')
      }
    })
    this.subscription = subscription
  }
});
