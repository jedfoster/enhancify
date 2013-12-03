describe 'An accordion form, ', ->
  form = null
  
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
    form.accordionify()

  describe 'when initially rendered, ', ->

    it 'should expand the first step by default', ->
      steps = form.find('.accordion-step')
      expect(steps[0]).toBeExpanded()
      expect(steps[1]).toBeCollapsed()
      expect(steps[2]).toBeCollapsed()

    it 'should display a continue button in the expanded step', ->
      firstStep = form.find('.accordion-step').first()
      expect(firstStep).toContain('button[type=button]')

  describe 'when a step is completed, ', ->
    firstStep = null
    secondStep = null

    beforeEach ->
      firstStep = form.find('.accordion-step').first()
      secondStep = firstStep.next()
      firstStep.find('button').click()

    it 'should collapse the completed step', ->
      expect(firstStep).toBeCollapsed()

    it 'should expand the next step', ->
      expect(secondStep).toBeExpanded()

  describe 'when a previous step header is clicked, ', ->
    firstStep = null
    secondStep = null

    beforeEach ->
      firstStep = form.find('.accordion-step').first()
      secondStep = firstStep.next()
      firstStep.find('button').click()
      firstStep.find('.accordion-header').click()

    it 'should collapse the current step', ->
      expect(secondStep).toBeCollapsed()
    
    it 'should expand the selected step', ->
      expect(firstStep).toBeExpanded()

    it 'should disable expansion for all steps after the selected step', ->
      secondStep.find('button').click()
      expect(secondStep).toBeCollapsed()
      expect(firstStep).toBeExpanded()
      



