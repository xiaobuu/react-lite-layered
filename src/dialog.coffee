
React = require 'react'
keycode = require 'keycode'

mixinLayered = require './mixin-layered'

Transition = React.createFactory require './transition'

div    = React.createFactory 'div'
span   = React.createFactory 'span'
a      = React.createFactory 'a'
button = React.createFactory 'button'

T = React.PropTypes
cx = require 'classnames'

module.exports = React.createClass
  displayName: 'lite-dialog'
  mixins: [mixinLayered]

  propTypes:
    # this components accepts children
    name:         T.string
    title:        T.string
    flexible:     T.bool
    getText:      T.func
    cancel:       T.string
    confirm:      T.string
    show:         T.bool.isRequired
    onCloseClick: T.func.isRequired
    onConfirm:    T.func.isRequired

  bindWindowEvents: ->
    window.addEventListener 'keydown', @onWindowKeydown

  unbindWindowEvents: ->
    window.removeEventListener 'keydown', @onWindowKeydown

  onWindowKeydown: (event) ->
    if keycode(event.keyCode) is 'esc'
      @onCloseClick()

  onCloseClick: ->
    @props.onCloseClick()

  onConfirmClick: ->
    @props.onConfirm()
    @props.onCloseClick()

  onBackdropClick: (event) ->
    if event.target is event.currentTarget
      @onCloseClick()

  renderActions: ->
    div className: 'actions line',
      button className: 'button is-link', onClick: @onCloseClick,
        if @props.getText? then @props.getText @props.cancel else @props.cancel
      button className: 'button is-danger', onClick: @onConfirmClick,
        if @props.getText? then @props.getText @props.confirm else @props.confirm

  renderLayer: (afterTransition) ->
    className = "lite-dialog is-for-#{@props.name}"
    boxClassName = cx 'box', 'flex': @props.flexible
    Transition transitionName: 'fade', enterTimeout: 200, leaveTimeout: 350,
      if @props.show and afterTransition
        div className: className, onClick: @onBackdropClick,
          div className: 'wrapper', onClick: @onBackdropClick,
            div className: boxClassName,
              if @props.title?
                div className: 'title',
                  span className: 'name', @props.title
                  span className: 'button-close icon icon-remove', onClick: @onCloseClick
              div className: 'content',
                @props.children
                @renderActions()

  render: ->
    div()
