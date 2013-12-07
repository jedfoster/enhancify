describe 'An accordion form, ', ->
  form = null
  isStepComplete = false
  
  beforeEach ->
    @addMatchers({
      toBeExpanded: ->
        for element in $(@actual).children()
          expect(element).toBeVisible()
      toBeCollapsed: ->
        for element in $(@actual).children().slice(1)
          expect(element).toBeHidden()   
      })

    jasmine.getFixtures().fixturesPath = 'spec/fixtures/';
    loadFixtures('accordionForm.html')
    form = $('#form1')
    form.accordionify(
      isStepComplete: (element) -> isStepComplete
      )

  describe 'when initially rendered, ', ->

    it 'should expand the first step by default', ->
      steps = form.find('.accordion-step')
      expect(steps[0]).toBeExpanded()
      expect(steps[1]).toBeCollapsed()
      expect(steps[2]).toBeCollapsed()

    it 'should display a continue button in the expanded step', ->
      firstStep = form.find('.accordion-step').first()
      expect(firstStep).toContain('button[type=button]')

  describe 'when a step is complete and the continue button is clicked, ', ->
    firstStep = null
    secondStep = null

    beforeEach ->
      isStepComplete = true
      firstStep = form.find('.accordion-step').first()
      secondStep = firstStep.next()
      firstStep.find('button').click()

    it 'should collapse the completed step', ->
      expect(firstStep).toBeCollapsed()

    it 'should display an edit button in the completed step header', ->
      expect(firstStep.find('.accordion-header')).toContain('button[type=button]')

    it 'should expand the next step', ->
      expect(secondStep).toBeExpanded()

  describe 'when a step is incomplete and the continue button is clicked, ', ->
    firstStep = null
    secondStep = null

    beforeEach ->
      isStepComplete = false
      firstStep = form.find('.accordion-step').first()
      secondStep = firstStep.next()
      firstStep.find('button').click()

    it 'should do nothing', ->
      expect(firstStep).toBeExpanded()
      expect(secondStep).toBeCollapsed()

  describe 'when an edit button is clicked, ', ->
    firstStep = null
    secondStep = null

    beforeEach ->
      firstStep = form.find('.accordion-step').first()
      secondStep = firstStep.next()
      firstStep.find('button').click()
      firstStep.find('.accordion-header button').click()

    it 'should collapse the current step', ->
      expect(secondStep).toBeCollapsed()
    
    it 'should expand the selected step', ->
      expect(firstStep).toBeExpanded()

    it 'should remove the edit button for all steps after the selected step', ->
      expect(secondStep.find('.accordion-header button')).toBeHidden()