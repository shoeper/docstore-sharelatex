sinon = require "sinon"
chai = require("chai")
chai.should()
{ObjectId} = require "mongojs"
async = require "async"

DocstoreClient = require "./helpers/DocstoreClient"

describe "Getting all docs", ->
	beforeEach (done) ->
		@project_id = ObjectId()
		@docs = [{
			_id: ObjectId()
			lines: ["one"]
			rev: 2
		}, {
			_id: ObjectId()
			lines: ["two"]
			rev: 4
		}, {
			_id: ObjectId()
			lines: ["three"]
			rev: 6
		}]
		DocstoreClient.createProject @project_id, (error) =>
			throw error if error?
			jobs = for doc in @docs
				do (doc) =>
					(callback) => DocstoreClient.createDoc @project_id, doc._id, doc.lines, callback
			async.series jobs, done 

	afterEach (done) ->
		DocstoreClient.deleteProject @project_id, done

	it "should return all the docs", (done) ->
		DocstoreClient.getAllDocs @project_id, (error, res, docs) =>
			throw error if error?
			docs.length.should.equal @docs.length
			for doc, i in docs
				doc.lines.should.deep.equal @docs[i].lines
			done()

