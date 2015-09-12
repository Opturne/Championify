should = require('chai').should()

hlp = null

describe 'lib/helpers.coffee', ->
  before ->
    hlp = require '../lib/helpers'

  describe 'wins', ->
    it 'should return win precentage', (done) ->
      hlp.wins(1).should.equal('1%')
      done()

  describe 'spliceVersion', ->
    it 'should return a two digit version number', (done) ->
      hlp.spliceVersion('1.2.3').should.equal('1.2')
      done()
