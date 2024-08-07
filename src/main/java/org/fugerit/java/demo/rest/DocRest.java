package org.fugerit.java.demo.rest;

import io.smallrye.common.annotation.RunOnVirtualThread;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.Response;
import lombok.extern.slf4j.Slf4j;
import org.fugerit.java.demo.facade.DocFacade;
import org.fugerit.java.doc.base.config.DocConfig;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
@Slf4j
@Path("/doc")
public class DocRest {

    DocFacade facade;

    public DocRest( DocFacade facade ) {
        this.facade = facade;
    }

    Response generateDocWorker( String chainId, String handleId ) {
        try (ByteArrayOutputStream baos = new ByteArrayOutputStream() ) {
            this.facade.handle( chainId, handleId, baos );
            log.info( "generateDocWorker, chainId:{}, free memory:{} / max memory:{}", chainId, Runtime.getRuntime().freeMemory()/1024/1024, Runtime.getRuntime().maxMemory()/1024/1024 );
            return Response.ok( baos.toByteArray() ).build();
        } catch (IOException e) {
            log.error( String.format( "Error : %s", e.getCause() ), e );
            return Response.status( Response.Status.INTERNAL_SERVER_ERROR ).build();
        }
    }

    @GET
    @Path("/pdf/{idDoc}.pdf")
    @Produces("application/pdf")
    @RunOnVirtualThread
    public Response handleDocPdf(@PathParam("idDoc") String idDoc) {
       return this.generateDocWorker( idDoc, DocConfig.TYPE_PDF );
    }

    @GET
    @Path("/pdf/handler/{idHandler}/{idDoc}.pdf")
    @Produces("application/pdf")
    @RunOnVirtualThread
    public Response handleDocPdf(@PathParam("idHandler") String idHandler, @PathParam("idDoc") String idDoc) {
        return this.generateDocWorker( idDoc, idHandler );
    }

}
