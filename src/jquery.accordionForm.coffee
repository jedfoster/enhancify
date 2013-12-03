(($) ->
  $.fn.accordionify = (options) ->
    return @each ->
      new AccordionForm(this, @options)
)(jQuery)

class AccordionForm
  constructor: (element, @options) ->
    @self = this
    @element = $(element)

    @options = $.extend({
        stepSelector: '.accordion-step',
        headerSelector: '.accordion-header',
        onExpand: (step) ->,
        onCollapse: (step) ->,
        onComplete: (step) ->
      },
      options)
    
    stepElements = @element.find(@options.stepSelector)
    @firstStep = @createStep(stepElements.first(), stepElements.slice(1))
    
    @currentStep = @firstStep
    @currentStep.expand()

  createStep: (element, nextElements) ->
    nextStep = if (nextElements.length > 0) then @createStep(nextElements.first(), nextElements.slice(1)) else null
    console.log(nextStep)
    new AccordionStep(element, nextStep, @options)

class AccordionStep
  constructor: (element, @next, @options) ->
    @element = $(element)
    @header = @element.find(@options.headerSelector)
    
    if @next?
      @appendEditButton()
      @appendContinueButton()

    @content = @header.siblings()

    @collapse()

  expand: ->
    @disableExpansion()
    @options.onExpand(this)
    @content.show()
    @collapseAndDisableExpansionForSubsequentSteps()

  collapse: ->
    @content.hide()
    @options.onCollapse(this)

  complete: ->
    if @validate()
      @collapse()
      @enableExpansion()
      @next.expand()
      @options.onComplete()

  appendEditButton: ->
    button = $('<button class="accordion-edit" type="button">Edit</button>')
    button.hide()
    button.click => @expand()
    @header.append(button)

  appendContinueButton: ->
    button = $('<button type="button">Continue</button>')
    button.click => @complete()
    @element.append(button)

  enableExpansion: ->
    @header.find('.accordion-edit').show()

  disableExpansion: ->
    @header.find('.accordion-edit').hide()

  collapseAndDisableExpansionForSubsequentSteps: ->
    pointer = @next
    while pointer?
      pointer.collapse()
      pointer.disableExpansion()
      pointer = pointer.next

  validate: ->
    return true