(($) ->
  $.fn.accordionify = (options) ->
    element = $(this[0])
    if (!element.data('accordionForm'))
      element.data('accordionForm', new AccordionForm(element, options))
    return element.data('accordionForm')

  class AccordionForm
    constructor: (@_element, options) ->
      @_options = $.extend(
          stepSelector: '.accordion-step',
          headerSelector: '.accordion-header',
          editButtonClass: 'accordion-edit',
          continueButtonClass: 'accordion-continue'
          isStepComplete: (element) -> true,
          onCollapse: (element) ->,
          onExpand: (element) ->,
        ,
        options)

      @_init()

    continue: ->
      if @_currentStep.isComplete() and !@_currentStep.isLast
        @_transitionTo(@_currentStep.index+1)
        return true
      return false

    goBackToStep: (index) ->
      targetStep = @_steps[index]
      if targetStep? and index < @_currentStep.index
        @_transitionTo(index)    
        @_collapseSubsequentSteps()

    refresh: ->
      @_reset()
      @_init()

    _init: ->
      stepElements = @_element.find(@_options.stepSelector)
      @_steps = stepElements.map (index, element) =>
        new AccordionStep(this, index, (index == stepElements.length-1), $(element), @_options)

      @_transitionTo(0)
      @_collapseSubsequentSteps()

    _transitionTo: (index) ->
      if @_currentStep? then @_currentStep.collapse(true)
      @_currentStep = @_steps[index]
      @_currentStep.expand()

    _collapseSubsequentSteps: ->
      for step in @_steps.slice(@_currentStep.index+1) 
        step.collapse(false)

    _reset: ->
      @_currentStep = null
      for step in @_steps
        step.reset()

  class AccordionStep
    constructor: (@_accordionForm, @index, @isLast, @_element, @_options) ->
      @_header = @_element.find(@_options.headerSelector)

      unless @isLast
        @_appendEditButton()
        @_appendContinueButton()

    expand: ->
      $('html, body').animate( { scrollTop: @_element.offset().top } );
      @_header.find('button.' + @_options.editButtonClass).hide()
      @_header.siblings().slideDown(500)
      @_options.onExpand(@_element[0])

    collapse: (showEditButton) ->
      editButton = @_header.find('button.' + @_options.editButtonClass)
      if (showEditButton) then editButton.show() else editButton.hide()
      @_header.siblings().hide()
      @_options.onCollapse(@_element[0])

    reset: ->
      @_header.siblings().show()
      @_header.find('button.' + @_options.editButtonClass).remove()
      @_element.find('button.' + @_options.continueButtonClass).remove()

    isComplete: ->
      return @_options.isStepComplete(@_element)

    _appendEditButton: ->
      button = $('<button type="button" class="' + @_options.editButtonClass + '">Edit</button>')
      button.hide()
      button.click => @_accordionForm.goBackToStep(@index)
      @_header.append(button)

    _appendContinueButton: ->
      button = $('<button type="button" class="' + @_options.continueButtonClass + '">Continue</button>')
      button.click => @_accordionForm.continue()
      @_element.append(button)

)(jQuery)