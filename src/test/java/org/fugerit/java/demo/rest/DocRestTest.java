package org.fugerit.java.demo.rest;

import io.quarkus.test.junit.QuarkusTest;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;

import java.util.List;

import static io.restassured.RestAssured.given;

@Slf4j
@QuarkusTest
class DocRestTest {

    @Test
    void testPdfSimpleTest01Default() {
        given()
                .when().get("/doc/pdf/simple-test-01.pdf")
                .then()
                .statusCode(200);
    }

    @Test
    void testPdfSimpleTest01Variant() {
        List<String> handlersPdf = List.of( "openpdf", "pdf-a-fop", "pdf-ua-fop", "pdf-fop" );
        List<String> chains = List.of( "simple-test-01" );
        chains.forEach( c -> handlersPdf.forEach( h -> {
                String url = "/doc/pdf/handler/"+h+"/"+c+".pdf";
                log.info( "handler: {}, chain: {}, url: {}", h, c, url );
                    given()
                            .when().get( url )
                            .then()
                            .statusCode(200);
                } ) );
    }

}
