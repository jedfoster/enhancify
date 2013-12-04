(($) ->
  $.fn.accordionify = (options) ->
    return @each ->
      new AccordionForm(this, options)

  class AccordionForm
    constructor: (element, options) ->
      @element = $(element)
      
      # Enable jquery validation
      @element.validate({
        ignore: ':hidden',
        showErrors: ->
        })

      @_options = $.extend(
          stepSelector: '.accordion-step',
          headerSelector: '.accordion-header'
        ,
        options)

      stepElements = @element.find(@_options.stepSelector)
      @steps = stepElements.map (index, element) =>
        new AccordionStep(this, index, (index == stepElements.length-1), element, @_options)

      @_transitionTo(0)
      @_collapseNextSteps()

    continue: ->
      return if @currentStep.isLast
      if @currentStepIsValid()
        @_transitionTo(@currentStep.index+1)

    goBackTo: (index) ->
      return if index < 0 or index >= @currentStep.index
      @_transitionTo(index)    
      @_collapseNextSteps()

    currentStepIsValid: ->
      return @element.valid()

    _transitionTo: (index) ->
      if @currentStep? then @currentStep.collapse(true)
      @currentStep = @steps[index]
      @currentStep.expand()

    _collapseNextSteps: ->
      for step in @steps.slice(@currentStep.index+1) 
        step.collapse(false)

  class AccordionStep
    constructor: (@accordionForm, @index, @isLast, element, @_options) ->
      @element = $(element)
      @header = @element.find(@_options.headerSelector)

      unless @isLast
        @appendEditButton()
        @appendContinueButton()

    expand: ->
      @header.siblings().slideDown(500)
      @header.find('button').hide()

    collapse: (showEditButton) ->
      @header.siblings().hide()
      if (showEditButton) then @header.find('button').show() else @header.find('button').hide()

    appendEditButton: ->
      button = $('<button type="button">Edit</button>')
      button.hide()
      button.click => @accordionForm.goBackTo(@index)
      @header.append(button)

    appendContinueButton: ->
      button = $('<button type="button">Continue</button>')
      button.click => @accordionForm.continue()
      @element.append(button)

)(jQuery)