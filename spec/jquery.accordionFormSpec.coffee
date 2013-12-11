describe 'An accordion form, ', ->
  form = null
  firstStep = null
  secondStep = null
  thirdStep = null
  mockValidator = -> true
  accordionForm = null
  
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
    firstStep = form.find('.accordion-step').first()
    secondStep = firstStep.next()
    thirdStep = secondStep.next()

    mockValidator = -> true
    accordionForm = form.accordionify(
      isStepComplete: (element) -> mockValidator()
      )

  describe 'when initially rendered, ', ->
    it 'should expand the first step by default', ->
      expect(firstStep).toBeExpanded()
      expect(secondStep).toBeCollapsed()
      expect(thirdStep).toBeCollapsed()

    it 'should display a continue button in the expanded step', ->
      firstStep = form.find('.accordion-step').first()
      expect(firstStep).toContain('button.accordion-continue')

  describe 'when a step is complete and the continue button is clicked, ', ->
    beforeEach ->
      mockValidator = -> true
      accordionForm.disableStep(1)
      firstStep.find('button.accordion-continue').click()

    it 'should collapse the completed step', ->
      expect(firstStep).toBeCollapsed()

    it 'should display an edit button in the completed step header', ->
      expect(firstStep.find('.accordion-header')).toContain('button.accordion-edit')

    it 'should expand the next enabled step', ->
      expect(secondStep).toBeCollapsed()
      expect(thirdStep).toBeExpanded()

  describe 'when a step is incomplete and the continue button is clicked, ', ->
    beforeEach ->
      mockValidator = -> false
      firstStep.find('button.accordion-continue').click()

    it 'should do nothing', ->
      expect(firstStep).toBeExpanded()
      expect(secondStep).toBeCollapsed()

  describe 'when an edit button is clicked, ', ->
    beforeEach ->
      accordionForm.continue()
      firstStep.find('button.accordion-edit').click()

    it 'should collapse the current step', ->
      expect(secondStep).toBeCollapsed()
    
    it 'should expand the selected step', ->
      expect(firstStep).toBeExpanded()

    it 'should not display the edit button in any steps after the selected step', ->
      expect(secondStep.find('button.accordion-edit')).toBeHidden()

  describe 'when the current step is disabled, ', ->
    beforeEach ->
      accordionForm.disableStep(0)

    it 'should collapse the disabled step', ->
      expect(firstStep).toBeCollapsed()

    it 'should not display an edit button in the disabled step header', ->
      expect(firstStep.find('button.accordion-edit')).toBeHidden()

    it 'should expand the next enabled step', ->
      expect(secondStep).toBeExpanded()

  describe 'when a step before the current step is enabled, ', ->
    beforeEach ->
      accordionForm.continue()
      accordionForm.disableStep(0)
      accordionForm.enableStep(0)

    it 'should collapse the current step', ->
      expect(secondStep).toBeCollapsed()
    
    it 'should expand the enabled step', ->
      expect(firstStep).toBeExpanded()

    it 'should not display the edit button in any steps after the selected step', ->
      expect(secondStep.find('button.accordion-edit')).toBeHidden()