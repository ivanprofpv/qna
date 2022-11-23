import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  if (document.querySelector('.answers')) {
    const question_element = document.getElementById('question-id')
    const question_id = question_element.getAttribute('data-question-id')

      var subscription = consumer.subscriptions.create( { channel: "AnswersChannel", question: question_id }, {
      connected() {
      },

      disconnected() {
      },

      received(data) {
        const user_element = document.getElementById('user-id')
        const user_id = user_element.getAttribute('data-user-id')

        if (user_id != data['user']) {
          $('.answers').append(data['html'])
        }
      }
    })
    this.subscription = subscription
  }
})
