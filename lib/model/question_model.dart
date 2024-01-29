class Question {
  String questionText;
  List<String> answerOptions;
  String correctAnswer;

  Question({
    required this.questionText,
    required this.answerOptions,
    required this.correctAnswer,
  });
}


List<Question> questions = [
  Question(
    questionText: 'What is the capital of France?',
    answerOptions: ['London', 'Paris', 'Rome', 'Madrid'],
    correctAnswer: 'Paris',
  ),
  Question(
    questionText: 'Which planet in our solar system is the largest?',
    answerOptions: ['Venus', 'Mars', 'Saturn', 'Jupiter'],
    correctAnswer: 'Jupiter',
  ),
  Question(
    questionText: 'Who painted the Mona Lisa?',
    answerOptions: ['Vincent van Gogh', 'Leonardo da Vinci', 'Pablo Picasso', 'Rembrandt'],
    correctAnswer: 'Leonardo da Vinci',
  ),
  Question(
    questionText: 'What is the smallest country in the world?',
    answerOptions: ['Monaco', 'Vatican City', 'San Marino', 'Liechtenstein'],
    correctAnswer: 'Vatican City',
  ),
  Question(
    questionText: 'Who wrote the Harry Potter series of books?',
    answerOptions: ['J.K. Rowling', 'Stephen King', 'Dan Brown', 'George R.R. Martin'],
    correctAnswer: 'J.K. Rowling',
  ),
  Question(
    questionText: 'What is the capital of Australia?',
    answerOptions: ['Sydney', 'Canberra', 'Melbourne', 'Perth'],
    correctAnswer: 'Canberra',
  ),
  Question(
    questionText: 'Who was the first person to step on the moon?',
    answerOptions: ['Neil Armstrong', 'Buzz Aldrin', 'Michael Collins', 'Yuri Gagarin'],
    correctAnswer: 'Neil Armstrong',
  ),
  Question(
    questionText: 'Which country won the FIFA World Cup in 2018?',
    answerOptions: ['Brazil', 'France', 'Germany', 'Argentina'],
    correctAnswer: 'France',
  ),
  Question(
    questionText: 'Who is the current CEO of Apple?',
    answerOptions: ['Tim Cook', 'Steve Jobs', 'Bill Gates', 'Elon Musk'],
    correctAnswer: 'Tim Cook',
  ),
  Question(
    questionText: 'Who invented the telephone?',
    answerOptions: ['Thomas Edison', 'Alexander Graham Bell', 'Samuel Morse', 'Guglielmo Marconi'],
    correctAnswer: 'Alexander Graham Bell',
  ),
];

