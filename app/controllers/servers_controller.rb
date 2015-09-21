class ServersController < ApplicationController

  def show
    @server = Server.find(params[:id])
    @conformance = FHIR::Conformance.new
    @tests = Test.all.sort {|l,r| l.name <=> r.name}
  end

  def conformance_metadata
    @server = Server.find(params[:id])
    @conformance = @server.load_conformance
    render layout: false, file: "servers/_metadata"
  end

  def create
    url = PostRank::URI.normalize(params['server']['url'])
    server = Server.where(url: url).first
    server = Server.new(params.require(:server).permit(:url, :name)) unless server
    server.save!
    redirect_to action: "show", id: server.id
  end

end
