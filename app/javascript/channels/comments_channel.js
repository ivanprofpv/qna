import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  const comments = $('.comments')

  if (comments.length) {
    if (consumer.subscriptions.subscriptions.some(s => s.identifier.includes('CommentsChannel'))) {
      return
    }

    consumer.subscriptions.create({ channel: 'CommentsChannel' }, {
      connected() {
        this.perform('follow')
      },

      received(data) {
        if (data.author_id != gon.user_id) {
          let commentElement = $('.comment_' + data.comment.commentable_type.toLowerCase() + '_' + data.comment.commentable_id)
          $(commentElement).find('.comments').append(data['html'])
        }
      }
    })
  }
})
