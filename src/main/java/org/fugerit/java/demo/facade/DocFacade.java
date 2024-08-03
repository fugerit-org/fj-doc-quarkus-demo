package org.fugerit.java.demo.facade;

import jakarta.enterprise.context.ApplicationScoped;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.fugerit.java.core.io.helper.HelperIOException;
import org.fugerit.java.doc.base.config.DocOutput;
import org.fugerit.java.doc.base.config.DocTypeHandler;
import org.fugerit.java.doc.base.process.DocProcessContext;
import org.fugerit.java.doc.freemarker.process.FreemarkerDocProcessConfig;
import org.fugerit.java.doc.freemarker.process.FreemarkerDocProcessConfigFacade;

import java.io.IOException;
import java.io.OutputStream;

@Slf4j
@ApplicationScoped
public class DocFacade {

    public DocFacade() {
        this.docConfig = FreemarkerDocProcessConfigFacade.loadConfigSafe( "cl://fj-doc-demo-config/freemarker-doc-process.xml" );
    }

    @Getter
    private FreemarkerDocProcessConfig docConfig;

    public void handle(String chainId, String handleId, OutputStream os) throws IOException {
        DocTypeHandler handler = this.docConfig.getFacade().findHandler( handleId );
        log.info( "handlerId : {}, handler : {}", handleId, handler );
        DocProcessContext context = DocProcessContext.newContext();
        DocOutput output = DocOutput.newOutput( os );
        HelperIOException.apply( () -> this.docConfig.fullProcess( chainId, context, handler, output ) );
    }

}
