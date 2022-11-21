import consumer from "./consumer"
import Question from "../components/question"
import React from 'react'
import ReactDOM from 'react-dom'

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    this.perform("follow")
  },

  disconnected() {
    console.log("disconnected")
  },

  received(data) {
    const questions = document.querySelector('.question_block_main')

    if (!questions) { return null }

    questions.append(document.createElement('p'))

    ReactDOM.render(
      <Question data={data} />,
      document.querySelector('.question_block_main p:last-child')
    )
  }
});