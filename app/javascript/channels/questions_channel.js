import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  if (document.querySelector('.question_block_main')){
    var subscription = consumer.subscriptions.create("QuestionsChannel", {
      connected() {
      },

      disconnected() {
      },

      received(data) {
        $('.question_block_main').append('<p><a href="/questions/' + data.id + '">' + data.title +'</a></p>')
      }
    })
    this.subscription = subscription
  }
});
