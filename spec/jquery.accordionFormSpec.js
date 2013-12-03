// Generated by CoffeeScript 1.6.3
describe('An accordion form, ', function() {
  var form;
  form = null;
  beforeEach(function() {
    this.addMatchers({
      toBeExpanded: function() {
        var element, _i, _len, _ref, _results;
        _ref = $(this.actual).children();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          element = _ref[_i];
          _results.push(expect(element).toBeVisible());
        }
        return _results;
      },
      toBeCollapsed: function() {
        var element, _i, _len, _ref, _results;
        _ref = $(this.actual).children().slice(1);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          element = _ref[_i];
          _results.push(expect(element).toBeHidden());
        }
        return _results;
      }
    });
    jasmine.getFixtures().fixturesPath = 'spec/fixtures/';
    loadFixtures('accordionForm.html');
    form = $('#form1');
    return form.accordionify();
  });
  describe('when initially rendered, ', function() {
    it('should expand the first step by default', function() {
      var steps;
      steps = form.find('.accordion-step');
      expect(steps[0]).toBeExpanded();
      expect(steps[1]).toBeCollapsed();
      return expect(steps[2]).toBeCollapsed();
    });
    return it('should display a continue button in the expanded step', function() {
      var firstStep;
      firstStep = form.find('.accordion-step').first();
      return expect(firstStep).toContain('button[type=button]');
    });
  });
  describe('when a step is completed, ', function() {
    var firstStep, secondStep;
    firstStep = null;
    secondStep = null;
    beforeEach(function() {
      firstStep = form.find('.accordion-step').first();
      secondStep = firstStep.next();
      return firstStep.find('button').click();
    });
    it('should collapse the completed step', function() {
      return expect(firstStep).toBeCollapsed();
    });
    return it('should expand the next step', function() {
      return expect(secondStep).toBeExpanded();
    });
  });
  return describe('when a previous step header is clicked, ', function() {
    var firstStep, secondStep;
    firstStep = null;
    secondStep = null;
    beforeEach(function() {
      firstStep = form.find('.accordion-step').first();
      secondStep = firstStep.next();
      firstStep.find('button').click();
      return firstStep.find('.accordion-header').click();
    });
    it('should collapse the current step', function() {
      return expect(secondStep).toBeCollapsed();
    });
    it('should expand the selected step', function() {
      return expect(firstStep).toBeExpanded();
    });
    return it('should disable expansion for all steps after the selected step', function() {
      secondStep.find('button').click();
      expect(secondStep).toBeCollapsed();
      return expect(firstStep).toBeExpanded();
    });
  });
});