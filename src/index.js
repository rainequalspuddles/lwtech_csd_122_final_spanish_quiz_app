import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import Flag_of_Spain from './Flag_of_Spain.svg'

    class Quiz extends React.Component {
        // difference from to do is that this has constructor with state
        constructor(props) {
            super(props);
            this.state = {
                questions: [
                    {question: 'Ahora tengo que ___ (ir, Yo) a clase.', answer: 'voy'},
                    {question: 'Ayer ellas ___ (caminar, Yo) en el parque.', answer: 'caminaron'},
                    {question: 'Cuando eran niños ___ (jugar, ellos) juntos.', answer: 'jugaban'},
                    {question: 'mañana ___ (comer, tu) cereal para el desayuno.', answer: 'comerás'},
                    {question: 'En el trabajo ___ (escribir, nosotros) código', answer: 'escribimos'}
                ], 
                currentQuestion: 0, 
                progress: [],
            };
            this.handleUserClickNextQuestioninQuiz = this.handleUserClickNextQuestioninQuiz.bind(this);
        }

        handleUserClickNextQuestioninQuiz(userGotQuestionCorrect) {
            // increment current quesiton index
            this.setState({
                currentQuestion: this.state.currentQuestion + 1,
            });
        }

        updateProgress(userGotQuestionCorrect) {
            let arrCopy=this.state.progress.slice()
            this.setState({
                progress: arrCopy.push(userGotQuestionCorrect)
            });
        }

        render() {
            return(
                <div class='App'>
                    <div className='App-header'>
                        <div>{this.state.progress}</div>
                        <img src={Flag_of_Spain} className='App-logo' alt='logo' />
                        <HeaderBar/>
                        <QuestionManager 
                            value={this.state.questions[this.state.currentQuestion]}
                            handleUserClickNextQuestioninQuiz={this.handleUserClickNextQuestioninQuiz}
                            updateProgress={this.updateProgress}
                        />
                    </div>
                </div>
            )
        }
    }

    class HeaderBar extends React.Component {
        render() {
            return(
                <div>
                    <body>
                        <h1>React Spanish Quiz App</h1>
                        <p>The sentence below contains a blank space, conjugate the verb in () to complete the sentence.</p>
                    </body>
                </div>
            )
        }
    }

    class QuestionManager extends React.Component {
        constructor(props) {
            super(props);
            this.state = {
                userAnswer: '',
                userSubmittedAnswerYet: false,
            }
            this.handleUserAnswerChange = this.handleUserAnswerChange.bind(this);
            this.handleUserAnswerSubmit = this.handleUserAnswerSubmit.bind(this);
            this.handleUserClickNextQuestioninQuestionManager = this.handleUserClickNextQuestioninQuestionManager.bind(this);
        }

        handleUserAnswerChange(answerText){
            this.setState({userAnswer: answerText});   
        }

        handleUserAnswerSubmit(event) {
            this.setState({userSubmittedAnswerYet: true});
            event.preventDefault();
        }

        handleUserClickNextQuestioninQuestionManager(event) {        
            // set userSubmittedAnswerYet to false
            this.setState({
                userAnswer: '',
                userSubmittedAnswerYet: false
            });

            // use callback to parent component
            this.props.handleUserClickNextQuestioninQuiz();
        }
 

        render() {
            return(
                <div>
                    <QuestionDisplay 
                        value={this.props.value}
                    />
                    <QuestionControls 
                        value={this.props.value}
                        handleUserAnswerChange={this.handleUserAnswerChange}
                        handleUserAnswerSubmit={this.handleUserAnswerSubmit}
                        handleUserClickNextQuestioninQuestionManager={this.handleUserClickNextQuestioninQuestionManager}
                    />
                    <QuestionMessage 
                        value={this.props.value}
                        userAnswer={this.state.userAnswer}
                        userSubmittedAnswerYet={this.state.userSubmittedAnswerYet}
                    />
                </div>
            )
        }
    }

    class QuestionDisplay extends React.Component {
        render() {
            return(
                <div>
                    {this.props.value.question}
                </div>
            )
        }
    }

    class QuestionControls extends React.Component {
        constructor(props) {
            super(props);
            this.handleUserAnswerChange = this.handleUserAnswerChange.bind(this);
            this.handleUserAnswerSubmit = this.handleUserAnswerSubmit.bind(this);
            this.handleUserClickNextQuestion = this.handleUserClickNextQuestion.bind(this);
        }

        handleUserAnswerChange(e){
            this.props.handleUserAnswerChange(e.target.value);
        }

        handleUserAnswerSubmit(e){
            this.props.handleUserAnswerSubmit(e);
        }

        handleUserClickNextQuestion(e) {
            this.props.handleUserClickNextQuestioninQuestionManager(e);
        }

        render() {
            return(
                <div>
                    <div>
                        <form onSubmit={this.handleUserAnswerSubmit}>
                            <label>
                            Answer Input:
                            <input type='text' onChange={this.handleUserAnswerChange} />
                            </label>
                            <input type='submit' value='Submit' />
                        </form>
                    </div>
                    <div>
                        <button className='button' onClick={this.handleUserClickNextQuestion}>{'Next Question'}</button>
                    </div>
                </div>
            )
        }
    }

    class QuestionMessage extends React.Component {
        render() {
            let message = '';
            let classType = '';
            if(this.props.userSubmittedAnswerYet) {
                if(this.props.userAnswer == this.props.value.answer) {
                    message = this.props.userAnswer + ' is the correct answer';
                    classType = 'Correct-answer';
                } else {
                    message = this.props.userAnswer + ' is an incorrect answer, the correct answer is ' + this.props.value.answer;
                    classType = 'Incorrect-answer';
                }
            }

            return(
                <div className={classType}>
                    {message}
                </div>
            )
        }
    }

  ReactDOM.render(<Quiz/>, document.getElementById('root'));